FROM ubuntu:20.04

# config environemnt:
ENV TZ Etc/UTC
ENV DEBIAN_FRONTEND=noninteractive

# install dependencies:
RUN apt-get update && apt-get -y install git cmake build-essential python3 python3-dev libboost-all-dev

# get and build Imath / PyImath:
RUN git clone https://github.com/AcademySoftwareFoundation/Imath.git --depth 1
RUN cd Imath && mkdir build && cd build && cmake .. -DPYTHON=ON && make && make install

# copy sources from the repo into the container:
COPY . /alembic
# RUN git clone http://github.com/alembic/alembic --depth 1

# build alembic and PyAlembic:
RUN mkdir -p alembic/build && cd alembic/build && cmake -DUSE_PYALEMBIC=ON .. && cmake --build . --config Release -- -j2

# add PyImath and PyAlembic to Python path:
RUN export PYTHONPATH="${PYTHONPATH}:/usr/local/lib/python3/dist-packages:/alembic/build/python/PyAlembic"
