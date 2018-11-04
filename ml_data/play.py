import threading
import sys, os

import firebase_admin
from firebase_admin import credentials
from firebase_admin import db

from google.cloud import automl_v1beta1
from google.cloud.automl_v1beta1.proto import service_pb2

from process import create_img

import cv2

answers = [""] * 40

def analyze_image(img_path):
    threads = []
    for i in range(40):
        create_img(img_path, i)
        with open('temp.png', 'rb') as ff:
            content = ff.read()
        os.remove("temp.png")

        answer = threading.Thread(target=get_prediction, args = (content, i), kwargs = {})
        threads.append(answer)
        answer.start()

    for i in threads:
        i.join()

    db.reference('/').set({'values' : answers })

def get_prediction(content, i, project_id="cs-342-219716", model_id="ICN8552997040222878665"):
    prediction_client = automl_v1beta1.PredictionServiceClient()

    name = 'projects/{}/locations/us-central1/models/{}'.format(project_id, model_id)
    payload = {'image': {'image_bytes': content }}
    params = {}
    response = prediction_client.predict(name, payload, params)
    s = response.payload[0].display_name
    answers[i] = s

if __name__ == '__main__':
    cred = credentials.Certificate("/Users/Bhavin/Downloads/cs-342-219716-5ca14b5f4042.json")
    firebase_admin.initialize_app(cred, {'databaseURL':'https://cs-342-219716.firebaseio.com/'})
    count = -10

    cap = cv2.VideoCapture('fastcars.mov')
    while(cap.isOpened()):
        count += 1
        ret, frame = cap.read()
        cv2.imshow('CCTV', frame)

        if count % 500 == 0:
            file_ext = "frame%d.png" % count
            if os.path.exists(file_ext):
                os.remove(file_ext)
            cv2.imwrite(file_ext, frame)
            x = threading.Thread(target=analyze_image, args = (file_ext,), kwargs = {})
            x.start()

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()
