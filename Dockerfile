FROM python:latest
LABEL description="This is a custom HEXTRIS container image"
MAINTAINER Gabriel O
EXPOSE 80
RUN git clone https://github.com/Hextris/hextris.git /hextris
WORKDIR /hextris
CMD ["python3", "-m", "http.server", "80"]
