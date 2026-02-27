import cv2
import numpy as np


VIDEO_PATH = "data/20260227_160705.mp4"
FRAME_STEP = 20


# ==============================
# 1. Просмотр видео (твой режим)
# ==============================
def preview_video(video_path):
    cap = cv2.VideoCapture(video_path)
    orb = cv2.ORB_create()

    i = 0
    while True:
        ret, frame = cap.read()
        if not ret:
            break

        frame_small = cv2.resize(
            frame,
            (int(frame.shape[1] * 0.5), int(frame.shape[0] * 0.5))
        )

        kp, des = orb.detectAndCompute(frame_small, None)
        img = cv2.drawKeypoints(
            frame_small, kp, None,
            color=(0, 255, 0),
            flags=0
        )

        cv2.imshow("Preview", img)

        if cv2.waitKey(25) & 0xFF == ord("q"):
            break

        i += 1

    cap.release()
    cv2.destroyAllWindows()


# ===================================
# 2. Извлечение кадров в список
# ===================================
def extract_frames(video_path, step=20):
    cap = cv2.VideoCapture(video_path)

    frames = []
    i = 0

    while True:
        ret, frame = cap.read()
        if not ret:
            break

        if i % step == 0:
            frames.append(frame)

        i += 1

    cap.release()

    print(f"Extracted {len(frames)} frames")
    return frames


# ===================================
# 3. Матчинг между двумя кадрами
# ===================================
def match_two_frames(frame1, frame2):
    orb = cv2.ORB_create()

    kp1, des1 = orb.detectAndCompute(frame1, None)
    kp2, des2 = orb.detectAndCompute(frame2, None)

    bf = cv2.BFMatcher(cv2.NORM_HAMMING, crossCheck=False)
    matches = bf.knnMatch(des1, des2, k=2)

    # Lowe ratio test
    good = []
    for m, n in matches:
        if m.distance < 0.75 * n.distance:
            good.append(m)

    print(f"Good matches: {len(good)}")

    img_matches = cv2.drawMatches(
        frame1, kp1,
        frame2, kp2,
        good, None,
        flags=cv2.DrawMatchesFlags_NOT_DRAW_SINGLE_POINTS
    )

    cv2.imshow("Matches", img_matches)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

    return kp1, kp2, good


# ===================================
# MAIN
# ===================================
if __name__ == "__main__":

    MODE = "preview"   # "preview" или "sfm"

    if MODE == "preview":
        preview_video(VIDEO_PATH)

    elif MODE == "sfm":
        frames = extract_frames(VIDEO_PATH, FRAME_STEP)

        if len(frames) < 2:
            print("Not enough frames!")
            exit()

        match_two_frames(frames[0], frames[1])