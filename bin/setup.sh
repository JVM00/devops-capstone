#!/bin/bash
echo "****************************************"
echo " Setting up Capstone Environment"
echo "****************************************"

echo "Installing Python 3.9 and Virtual Environment"
sudo apt-get update
#sudo DEBIAN_FRONTEND=noninteractive apt-get install -y python3.9 python3.9-venv
#sudo DEBIAN_FRONTEND=noninteractive apt-get install -y python3 python3-venv
sudo apt update
sudo apt update
sudo apt install libsqlite3-dev
sudo apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev \
libnss3-dev libssl-dev libreadline-dev libffi-dev curl libbz2-dev
  
current_dir=$(pwd)
echo "Saving current directory: $current_dir"

cd /tmp
curl -O https://www.python.org/ftp/python/3.9.18/Python-3.9.18.tgz
tar -xzf Python-3.9.18.tgz
cd Python-3.9.18
./configure --enable-optimizations
make -j$(nproc)
sudo make altinstall 

# Later on, move back to it
cd "$current_dir"
echo "Returned to: $(pwd)"
echo "Checking the Python version..."
python3.9 --version
#python3 --version

echo "Creating a Python virtual environment"
python3.9 -m venv ~/venv
#python3 -m venv ~/venv

echo "Configuring the developer environment..."
echo "# DevOps Capstone Project additions" >> ~/.bashrc
echo "export GITHUB_ACCOUNT=$GITHUB_ACCOUNT" >> ~/.bashrc
echo 'export PS1="\[\e]0;\u:\W\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ "' >> ~/.bashrc
echo "source ~/venv/bin/activate" >> ~/.bashrc

echo "Installing Python dependencies..."
source ~/venv/bin/activate && python3.9 -m pip install --upgrade pip wheel
#source ~/venv/bin/activate && python3 -m pip install --upgrade pip wheel
source ~/venv/bin/activate && pip install -r requirements.txt

echo "Starting the Postgres Docker container..."
make db

echo "Checking the Postgres Docker container..."
docker ps


echo "install further requirements"
pip install -r requirements.txt

echo "****************************************"
echo " Capstone Environment Setup Complete"
echo "****************************************"
echo ""
echo "Use 'exit' to close this terminal and open a new one to initialize the environment"
echo ""
