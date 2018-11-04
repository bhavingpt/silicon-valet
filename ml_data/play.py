import threading
import sys, os

import firebase_admin
from firebase_admin import credentials
from firebase_admin import db

from google.cloud import automl_v1beta1
from google.cloud.automl_v1beta1.proto import service_pb2

from process import create_img

import cv2

answers = ["No data"] * 40

def analyze_image(img_path):
    threads = []
    for i in range(7):
        create_img(img_path, i)
        with open('temp.png', 'rb') as ff:
            content = ff.read()
        os.remove("temp.png")

        answer = threading.Thread(target=get_prediction, args = (content, i), kwargs = {})
        threads.append(answer)
        answer.start()

    for i in range(7, 40):
        answers[i] = "full" # Vid was sped up & GCloud limits requests, so we cut requests by ~1/5

    for i in threads:
        i.join()

    empty = [j for j in range(len(answers)) if answers[j] == "empty"]
    print('    Successfully updated the database. Empty spots: ' + str(empty))
    db.reference('/').set({'values' : answers })

def get_prediction(content, i, project_id="cs-342-219716", model_id="ICN449410086403265780"):
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
    
    x = None

    cap = cv2.VideoCapture('fastcars.mov')
    cv2.namedWindow("CCTV", cv2.WINDOW_NORMAL)
    cv2.resizeWindow("CCTV", 700, 700)
    while(cap.isOpened()):
        count += 1
        ret, frame = cap.read()
        try:
            cv2.imshow('CCTV', frame)
            cv2.resizeWindow("CCTV", 700, 450)
        except:
            break

        if count % 600 == 0:
            print("Sending image to GCloud for analysis...")
            if x != None:
                #x.join()
                pass
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
