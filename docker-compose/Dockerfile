FROM python:3.5-alpine 
LABEL maintainer="lbbxsxlz@gmail.com"
ADD . /counter-code
WORKDIR /counter-code
RUN pip install -r requirements.txt
CMD ["python", "app.py"]

