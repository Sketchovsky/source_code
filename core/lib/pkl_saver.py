import pickle
import os

class PklSaver:

    def __init__(self, folder_path, fn):
        os.makedirs(folder_path, exist_ok=True)
        self.folder_path = folder_path
        self.fn = fn
        self.full_path = os.path.join(folder_path, fn)

    def file_exist(self):
        return os.path.exists(self.full_path)

    def save(self, data):
        print("[PklSaver] data saved to (%s) (%s)" % (self.fn, self.folder_path))
        with open(self.full_path, 'wb') as f:
            pickle.dump(data, f)

    def load(self):
        with open(self.full_path, 'rb') as f:
            pkl_data = pickle.load(f)
            return pkl_data
