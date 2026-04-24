#!/bin/bash

# 1. Setup Variables
BUILD_MODE="FALSE"
VERBOSE="FALSE"
CAMERA_MODEL="zed2i"

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
WORKING_DIR="$SCRIPT_DIR"

CONDA_ROBROS_ENV="zed_ros2_env"
CONDA_BASE=$(conda info --base 2>/dev/null || echo "$HOME/anaconda3")
CONDA_INIT_PATH="$CONDA_BASE/etc/profile.d/conda.sh"

# 2. Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -b|--build)
      BUILD_MODE="true"
      shift 
      ;;
    -r|--rviz)
      RVIZ="TRUE"
      shift
      ;;    
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# 3. Initialize Conda for this script and activate environment
if [ -f "$CONDA_INIT_PATH" ]; then
    source "$CONDA_INIT_PATH"
    if conda info --envs | grep -q "$CONDA_ROBROS_ENV"; then
        conda activate "$CONDA_ROBROS_ENV"
    else
        echo "Error: $CONDA_ROBROS_ENV not found."
        conda env list
        exit 1
    fi
else
    echo "Error: Could not find conda.sh at $CONDA_INIT_PATH"
    exit 1
fi

# 4. Move to the workspace directory
if [ -d "$WORKING_DIR" ]; then
    cd "$WORKING_DIR"
else
    echo "Directory $WORKING_DIR does not exist."
    exit 1
fi

# 5. Build and Source the ROS 2 setup script
if [ "$BUILD_MODE" = "true" ]; then
    echo "Building the workspace..."
    rm -rf build/ install/ log/ debug/
    colcon build --cmake-args -DPython3_EXECUTABLE=$(which python)
    source install/setup.bash
elif [ -f "install/setup.bash" ]; then
    echo "Sourcing the workspace..."
    source install/setup.bash
else
    echo "Workspace not built. Run with: ./run_sh --build"
    exit 1
fi

# 6. Run Launch files
echo "Launching ZED ROS 2 node..."
if [ "$RVIZ" = "TRUE" ]; then
   ros2 launch zed_display_rviz2 display_zed_cam.launch.py camera_model:=$CAMERA_MODEL
else
   ros2 launch zed_wrapper zed_camera.launch.py camera_model:=$CAMERA_MODEL
fi


