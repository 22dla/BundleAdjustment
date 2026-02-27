import cv2

cap = cv2.VideoCapture("data/20260227_160705.mp4")
if not cap.isOpened():
    print("Error opening video stream or file")

save_path = "data/frames/"
save_flag = False
show_flag = True
orb = cv2.ORB_create()

i = 0
while cap.isOpened():
    ret, frame = cap.read()
    if not ret:
        break

    if(save_flag and i % 20 == 0):
        cv2.imwrite(f"{save_path}Frame {i}.png", frame)

    if show_flag:
        frame = cv2.resize(frame, (int(frame.shape[1]*0.5), int(frame.shape[0]*0.5)))
        kp = orb.detect(frame, None)
        kp, des = orb.compute(frame, kp)
        img2 = cv2.drawKeypoints(frame, kp, None, color=(0,255,0), flags=0)

        cv2.imshow("Frame", img2)

    if cv2.waitKey(25) & 0xFF == ord("q"):
        break

    i += 1

    print("Showing frame " + str(i))

