from flask import Flask, request, jsonify
from flask_cors import CORS
import pandas as pd
from fft_module import compute_fft

app = Flask(__name__)
CORS(app)  # разрешаем запросы с frontend

@app.route("/upload", methods=["POST"])
def upload_file():
    file = request.files.get("file")

    if not file:
        return jsonify({"error": "Файл не передан"}), 400

    try:
        data = pd.read_csv(file)
        signal = data.iloc[:, 0].tolist()
        return jsonify({
            "signal": signal
        })
    except Exception as e:
        return jsonify({"error": f"Ошибка чтения CSV: {str(e)}"}), 500


@app.route("/fft", methods=["POST"])
def run_fft():
    body = request.get_json()

    if not body or "signal" not in body:
        return jsonify({"error": "Сигнал не передан"}), 400

    try:
        signal = body["signal"]
        fft_result = compute_fft(signal)

        # если compute_fft возвращает numpy array
        fft_result = list(fft_result)

        return jsonify({
            "fft": fft_result
        })
    except Exception as e:
        return jsonify({"error": f"Ошибка FFT: {str(e)}"}), 500


if __name__ == "__main__":
    app.run(debug=True)
