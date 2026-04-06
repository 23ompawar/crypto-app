from bottle import Bottle, run, template, request, TEMPLATE_PATH
import json
import requests
import numpy as np
from sklearn.linear_model import LinearRegression
import os

app = Bottle()

# Fix template path (IMPORTANT for Render)
TEMPLATE_PATH.insert(0, './')

# Coin mapping
coin_map = {
    "bitcoin": "bitcoin",
    "ethereum": "ethereum",
    "dogecoin": "dogecoin",
    "litecoin": "litecoin",
    "ripple": "ripple"
}

# Get real-time data
def get_crypto_data(coin):
    try:
        url = f"https://api.coingecko.com/api/v3/coins/{coin}/market_chart?vs_currency=usd&days=7"
        response = requests.get(url, timeout=5)
        data = response.json()

        prices = data.get('prices', [])

        labels = []
        price_values = []

        for i, item in enumerate(prices):
            labels.append(i + 1)
            price_values.append(item[1])

        return labels, price_values

    except Exception as e:
        print("API ERROR:", e)
        return [], []

# Train model
def train_model(labels, prices):
    X = np.array(labels).reshape(-1, 1)
    y = np.array(prices)

    model = LinearRegression()
    model.fit(X, y)

    return model

# Home route
@app.route('/')
def home():
    labels, prices = get_crypto_data("bitcoin")

    labels_str = [f"Day {i}" for i in labels]

    return template(
        'home',
        prediction=None,
        coin="bitcoin",
        labels=json.dumps(labels_str),
        prices=json.dumps(prices)
    )

# Predict route (SAFE)
@app.route('/predict', method='POST')
def predict():
    try:
        coin_input = request.forms.get('coin') or "bitcoin"
        day_input = request.forms.get('day')

        if not day_input or not day_input.isdigit():
            day = 1
        else:
            day = int(day_input)

        coin = coin_map.get(coin_input.lower(), "bitcoin")

        labels, prices = get_crypto_data(coin)

        # fallback if API fails
        if not labels or not prices:
            labels = [1,2,3,4,5,6,7]
            prices = [10,20,30,40,50,60,70]

        try:
            model = train_model(labels, prices)
            predicted_price = model.predict([[day]])[0]
        except:
            predicted_price = prices[-1]

        labels_str = [f"Day {i}" for i in labels]
        labels_str.append("Predicted")

        prices.append(predicted_price)

        return template(
            'home',
            prediction=round(predicted_price, 2),
            coin=coin,
            labels=json.dumps(labels_str),
            prices=json.dumps(prices)
        )

    except Exception as e:
        return f"ERROR: {str(e)}"

# Run for Render
port = int(os.environ.get("PORT", 10000))
run(app, host='0.0.0.0', port=port)