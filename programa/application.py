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
    data = pd.read_csv(filename, delimiter=";")

    # Contar incidencias por estado
    incidencias_por_estado = data.groupby("Estado").size()

    # Crear gráfico de barras
    fig, ax = plt.subplots()
    incidencias_por_estado.plot(kind="bar", ax=ax)
    ax.set_xlabel("Estado")
    ax.set_ylabel("Número de incidencias")
    ax.set_title("Incidencias por estado")

    # Crear objeto FigureCanvasTkAgg
    canvas = FigureCanvasTkAgg(fig, master=root)
    canvas.draw()
    canvas.get_tk_widget().pack()


file_menu = Menu(menubar, tearoff=0)
menubar.add_cascade(label="Archivo", menu=file_menu)

file_menu.add_command(label="Abrir", command=abrir_csv)
file_menu.add_separator()
file_menu.add_command(label="Salir", command=root.quit)

root.mainloop()
