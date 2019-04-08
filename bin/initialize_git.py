import os
import shutil
import subprocess
import tempfile


if __name__ == "__main__":

    repository_path = os.getcwd()

    repository_url = "https://github.com/tokejepsen/avalon-environment.git"

    print("Making \"{0}\" into git repository.".format(repository_path))

    # Copy .git directory from cloned repository
    tempdir = tempfile.mkdtemp()
    subprocess.call(["git", "clone", repository_url], cwd=tempdir)
    src = os.path.join(tempdir, "avalon-environment", ".git")
    dst = os.path.join(repository_path, ".git")
    shutil.copytree(src, dst)

    # Initialising git repository
    subprocess.call(["git", "init"])
    subprocess.call(["git", "add", "."])
