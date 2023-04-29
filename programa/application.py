from tkinter import *
from tkinter import filedialog
import pandas as pd
import matplotlib.pyplot as plt

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

    # Mostrar los gráficos
    plt.show()


file_menu = Menu(menubar, tearoff=0)
menubar.add_cascade(label="Archivo", menu=file_menu)

file_menu.add_command(label="Abrir", command=abrir_csv)
file_menu.add_separator()
file_menu.add_command(label="Salir", command=root.quit)

root.mainloop()
