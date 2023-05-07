import sys
from PyQt5.QtWidgets import QApplication, QWidget, QLabel, QVBoxLayout, QMainWindow, QAction, qApp, QFileDialog
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.backends.backend_qt5agg import NavigationToolbar2QT as NavigationToolbar
import matplotlib.pyplot as plt
import random


class App(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("GLPI Companion")
        self.setGeometry(0, 0, 1000, 1000)

        # Crear acciones para el menú
        openAct = QAction("Abrir", self)
        openAct.setShortcut("Ctrl+O")
        openAct.triggered.connect(self.abrir_archivo)
        exitAct = QAction("Salir", self)
        exitAct.setShortcut("Ctrl+Q")
        exitAct.triggered.connect(qApp.quit)

        # Crear menú de archivo
        menubar = self.menuBar()
        fileMenu = menubar.addMenu("Archivo")
        fileMenu.addAction(openAct)
        fileMenu.addAction(exitAct)

        self.show()

    def abrir_archivo(self):
        filename, _ = QFileDialog.getOpenFileName(self, "Abrir archivo", "", "Archivos CSV (*.csv)")
        if filename:
            data = self.cargar_datos(filename)
            self.mostrar_grafico(data)

    def cargar_datos(self, filename):
        # Cargar los datos desde el archivo CSV
        # Aquí se usaría la librería Pandas para cargar los datos desde el archivo CSV
        # y devolverlos en un formato adecuado para graficarlos
        data = [random.randint(0, 100) for _ in range(10)]
        return data

    def mostrar_grafico(self, data):
        # Crear una figura y un canvas para mostrar el gráfico
        fig = plt.figure()
        canvas = FigureCanvas(fig)

        # Crear el gráfico de barras
        ax = fig.add_subplot()
        ax.bar(range(len(data)), data)

        # Crear la barra de herramientas para el gráfico
        toolbar = NavigationToolbar(canvas, self)

        # Crear el layout de la ventana y agregar el canvas y la barra de herramientas
        layout = QVBoxLayout()
        layout.addWidget(canvas)
        layout.addWidget(toolbar)

        # Crear el widget principal y agregarle el layout
        widget = QWidget()
        widget.setLayout(layout)

        # Mostrar la ventana con el gráfico
        self.setCentralWidget(widget)


if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = App()
    ex.show()
    sys.exit(app.exec_())
