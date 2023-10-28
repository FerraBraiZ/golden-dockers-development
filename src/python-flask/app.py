import json
import os
from dotenv import load_dotenv, dotenv_values
from flask import Flask, make_response, request
from flask_cors import CORS

load_dotenv()  # take environment variables from .env.
config = dotenv_values("../.env")
app = Flask(__name__)
cors = CORS(app, resources={r"/*": {"origins": "*"}})


def create_response(data, status_code=200):

    return make_response({
        "isBase64Encoded": False,
        "statusCode": status_code,
        "headers": {},
        "multiValueHeaders": {},
        "body": {"message": data},
    }, status_code)


@app.route("/", methods=["GET"])
def alive():
    try:
        return create_response({"response": "Everything is gona be 200"})
    except Exception as e:
        return create_response({"error": str(e)}, status_code=500)


@app.route("/test", methods=["GET"])
def test():
    try:
        return create_response({"response": "Everything is gona be 200"})
    except Exception as e:
        return create_response({"error": str(e)}, status_code=500)


@app.route("/ranho", methods=["GET"])
def test3():
    try:
        return create_response({"response": "Everything is gona be 200"})
    except Exception as e:
        return create_response({"error": str(e)}, status_code=500)


if __name__ == "__main__":
    app.run()

