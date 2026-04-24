# ZED ROS 2 Workspace

A managed **ROS 2 Jazzy** workspace for Stereolabs ZED cameras. This repository uses **Git Submodules** to manage official ZED packages and **Conda (Robostack)** to isolate the ROS 2 environment and its Python dependencies.

## 📁 Project Structure

* **`src/`**: Contains the ZED ROS 2 submodules (Wrapper, Interfaces, Examples, and Description).
* **`run.sh`**: A dynamic utility script for environment activation, building, and launching.
* **`environment.yml`**: The Conda recipe containing the Robostack-Jazzy suite and ZED dependencies.

## 🛠 Installation

### 1. Clone everything (including the submodules)
```bash
    git clone --recursive https://github.com/pompetzki/zed_ros2_ws.git && cd zed_ros2_ws
```

### 2. Create the environment from the recipe
```bash
conda env create -f environment.yml
```

### 3. Build and launch
```bash
    ./run.sh --build -r
```
