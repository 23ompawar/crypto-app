<!DOCTYPE html>
<html>
<head>
    <title>{{coin.capitalize()}} Price Prediction</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", sans-serif;
            background: radial-gradient(circle at top, #1f3b44, #0f2027);
            color: white;
        }

        .container {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            gap: 30px;
            flex-wrap: wrap;
        }

        .card {
            background: #2b4650;
            border-radius: 18px;
            padding: 30px;
            width: 420px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.4);
        }

        h1 {
            color: #ff9f1c;
        }

        select, input {
            width: 100%;
            padding: 14px;
            border-radius: 10px;
            border: none;
            margin-bottom: 15px;
            background: #455a64;
            color: white;
        }

        button {
            width: 100%;
            padding: 14px;
            border-radius: 30px;
            border: none;
            background: linear-gradient(135deg, #ff512f, #f09819);
            cursor: pointer;
        }

        .price {
            margin-top: 20px;
            font-size: 22px;
            color: #00ffd5;
            font-weight: bold;
        }

        canvas {
            background: #29434e;
            border-radius: 15px;
            padding: 15px;
        }
    </style>
</head>

<body>

<div class="container">

    <!-- LEFT -->
    <div class="card">
        <h1>{{coin.capitalize()}} Price Prediction</h1>

        <form method="post" action="/predict">
            <select name="coin">
                <option value="bitcoin" {{'selected' if coin=='bitcoin' else ''}}>Bitcoin</option>
                <option value="ethereum" {{'selected' if coin=='ethereum' else ''}}>Ethereum</option>
                <option value="dogecoin" {{'selected' if coin=='dogecoin' else ''}}>Dogecoin</option>
                <option value="litecoin" {{'selected' if coin=='litecoin' else ''}}>Litecoin</option>
                <option value="ripple" {{'selected' if coin=='ripple' else ''}}>Ripple</option>
            </select>

            <input type="number" name="day" placeholder="Enter future day (e.g., 8)" required>

            <button type="submit">Predict Price</button>
        </form>

        % if prediction:
            <div class="price">Predicted Price: ${{prediction}}</div>
        % end
    </div>

    <!-- RIGHT -->
    <div class="card">
        <h1>{{coin.capitalize()}} Chart</h1>
        <canvas id="priceChart"></canvas>
    </div>

</div>

<script>
    const labels = {{!labels}};
    const prices = {{!prices}};
    const coinName = "{{coin.capitalize()}}";

    if (labels.length > 0) {
        new Chart(document.getElementById("priceChart"), {
            type: "line",
            data: {
                labels: labels,
                datasets: [{
                    label: coinName + " Price ($)",
                    data: prices,
                    borderColor: "#ffd60a",
                    backgroundColor: "rgba(255,214,10,0.25)",
                    tension: 0.4,
                    fill: true
                }]
            }
        });
    }
</script>

</body>
</html>