# linear_regression.py

import numpy as np

class LinearRegressionGD:
    def __init__(self, learning_rate=0.001, iterations=5000):  # Adjusted learning rate and iterations
        self.learning_rate = learning_rate
        self.iterations = iterations
        self.weights = None
        self.bias = None
        self.loss_history = []  # Store loss at each iteration

    def fit(self, X, y):
        m, n = X.shape
        self.weights = np.zeros(n)
        self.bias = 0

        for i in range(self.iterations):
            y_pred = np.dot(X, self.weights) + self.bias
            error = y_pred - y

            dw = (1 / m) * np.dot(X.T, error)
            db = (1 / m) * np.sum(error)

            self.weights -= self.learning_rate * dw
            self.bias -= self.learning_rate * db

            # Store loss at each iteration
            self.loss_history.append(self.calculate_loss(X, y))

    def predict(self, X):
        return np.dot(X, self.weights) + self.bias

    def calculate_loss(self, X, y):
        y_pred = self.predict(X)
        return (1 / (2 * len(y))) * np.sum((y_pred - y) ** 2)
