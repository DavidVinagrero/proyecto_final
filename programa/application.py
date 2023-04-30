from tkinter import *
from tkinter import filedialog
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg

# Configuración ventana
root = Tk()
root.title("Visualizador de diagramas")
root.iconbitmap("static/logo.ico")
root.geometry("500x500")

# Menu bar
menubar = Menu(root)
root.config(menu=menubar)


# Funciones menu bar
def abrir_csv():
    # Pedir al usuario que seleccione el archivo CSV
    filename = filedialog.askopenfilename(title="Seleccione un archivo CSV", filetypes=[("CSV Files", "*.csv")])

    # Leer el archivo CSV
    data = pd.read_csv(filename)

    # Mostrar los primeros 5 registros del archivo CSV (por consola)
    print(data.head())

    # Crear un gráfico de barras con la columna "Cantidad" del archivo CSV
    fig = plt.figure(figsize=(6, 4))
    data.plot.bar(x="cantidad", y="precio", ax=fig.add_subplot(111))
    plt.tight_layout()

    # Crear un objeto FigureCanvasTkAgg con el gráfico de barras y la ventana de Tkinter
    canvas = FigureCanvasTkAgg(fig, master=root)
    canvas.draw()

    # Mostrar el objeto FigureCanvasTkAgg en la ventana de Tkinter
    canvas.get_tk_widget().pack(side=TOP, fill=BOTH, expand=1)


file_menu = Menu(menubar, tearoff=0)
menubar.add_cascade(label="Archivo", menu=file_menu)

file_menu.add_command(label="Abrir", command=abrir_csv)
file_menu.add_separator()
file_menu.add_command(label="Salir", command=root.quit)

root.mainloop()
