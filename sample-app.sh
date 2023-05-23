#!/bin/bash

rm -rf tempdir
mkdir tempdir
mkdir tempdir/templates
mkdir tempdir/static

cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

echo "FROM python" >> tempdir/Dockerfile
echo "RUN pip install flask" >> tempdir/Dockerfile
echo "COPY ./static /home/myapp/static/" >> tempdir/Dockerfile
echo "COPY ./templates /home/myapp/templates/" >> tempdir/Dockerfile
echo "COPY sample_app.py /home/myapp/" >> tempdir/Dockerfile
echo "EXPOSE 5050" >> tempdir/Dockerfile
echo "CMD python /home/myapp/sample_app.py" >> tempdir/Dockerfile

cd tempdir

# Verifica si Docker está instalado y disponible en el entorno de Jenkins
if ! [ -x "$(command -v docker)" ]; then
  echo 'Error: Docker no está instalado o no se encuentra en la ruta adecuada.' >&2
  exit 1
fi

docker build -t jenki .
docker run -t -d -p 5050:5050 --name jenkimg jenki
docker ps -a

