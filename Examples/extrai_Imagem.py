from PIL import Image
import numpy as np

#digita o nome da imagem aq
imagem = Image.open("Vista_da_paisagem.jpg")

#converte para RGB
imagem = imagem.convert("RGB")

#transforma em array pra separar por canal
array = np.array(imagem)

#separa os canais
canal_r = array[:, :, 0]
canal_g = array[:, :, 1]
canal_b = array[:, :, 2]

print(canal_r[0][0])
#salva cada canal em arquivo .data
canal_r.tofile("CanalR.data")
canal_g.tofile("CanalG.data")
canal_b.tofile("CanalB.data")

print("canais RGB extraídos e salvos com sucesso!")