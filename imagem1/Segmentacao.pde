void setup() {
  size(1200, 640);
  noLoop();
}

void draw() {
  PImage img = loadImage("img1.jpg");
  PImage imgMask = loadImage("img1 - mask.png");
  PImage aux =  loadImage("img1.jpg");
  PImage aux2 = createImage(img.width, img.height, RGB);
   

  // Filtro de limiarização
   aux = limiarizarCinza(aux);
   verificarPixel(imgMask,aux);
   aux2 = addImageNoG(aux,aux2,img);
  
  image(img,0,0);
  image(aux,aux.width+10,0);
  image(aux2,aux2.width*2+20,0);
  image(imgMask,0,img.height + 10);
  //image(aux2,(img.width + 10),0);
  //image(imgG,(img.width + 10),img.height+ 10);
  //image(imgJanela,((img.width*3) + 10),0);
  //linhasOrientacao();
}


//limiariraz
// Verifica os tons de cinza e os tons entre a faixa cinza1 e cinza2 são pintados de preto

PImage limiarizarCinza(PImage aux2){  
   for (int y = 0; y < aux2.height; y++) {
    for (int x = 0; x < aux2.width; x++) {
      int pos = (y)*aux2.width + (x);
      //int media = int(red(aux2.pixels[pos]) + green(aux2.pixels[pos]) + blue(aux2.pixels[pos]))/3;
      if(blue(aux2.pixels[pos]) < 90 && y > 55 || x>40 && x < 90 && y > 90 && y < 150 || green(aux2.pixels[pos]) > 165 && x >150 && x < 250 && y < 235) aux2.pixels[pos] = color(255);
      else aux2.pixels[pos] = color(0);
      
    }
  }
  return aux2;
}



//escala cinza
//transforma a imagem em escala de cinza
PImage filtroEscalaCinza(PImage aux, PImage img){
    for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {

      int pos = (y)*img.width + (x);
      //int media = int((green(img.pixels[pos]) + red(img.pixels[pos]))/2);
      int media = int(green(img.pixels[pos]));
      aux.pixels[pos] = color(media);
    }
  }
  return aux;
}

PImage addImageNoG(PImage imgG, PImage imgGcomImagem, PImage imgOriginal){
  for (int y = 0; y < imgG.height; y++) {
    for (int x = 0; x < imgG.width; x++) {      
      int pos = (y)*imgG.width + (x);
      if(blue(imgG.pixels[pos]) > 0)imgGcomImagem.pixels[pos] = imgOriginal.pixels[pos];
    }
  }
  return imgGcomImagem;
}

//Media de janela flutuante
//borra a imagem conforme o tamanho da janela

PImage filtroMediaJanela(PImage aux,int jan){
    // Filtro de Média com Janela Deslizante
  for (int y = 0; y < aux.height; y++) {
    for (int x = 0; x < aux.width; x++) {
      //int jan = 9;
      int pos = y*aux.width + x; /* acessa o ponto em forma de vetor */

      float media = 0;
      int qtde = 0;

      for (int i = jan*(-1); i <= jan; i++) {
        for (int j = jan*(-1); j <= jan; j++) {
          int disy = y+i;
          int disx = x+j;
          if (disy >= 0 && disy < aux.height &&
            disx >= 0 && disx < aux.width) {
            int pos_aux = disy * aux.width + disx;
            float r = blue(aux.pixels[pos_aux]);
            media += r;
            qtde++;
          }
        }
      }
      media = media / qtde;
      aux.pixels[pos] = color(media);
    }
  }
  
  return aux;
}

// verificar pixels
void verificarPixel(PImage original,PImage novaImage){
  int count = 0;
  int falsoN = 0,falsoP = 0, verdadeiro = 0;
  float percentFN = 0,percentFP = 0,percentV = 0;
  
  if(original.height == novaImage.height && original.width == novaImage.width){
 println("IMAGENS DE DIMENSÕES IGUAIS");
  int posO, posN;
  int pAuxO, pAuxN;
  
  
  for (int y = 0; y < original.height; y++) {
    for (int x = 0; x < original.width; x++) {  
      count++;
      posO = (y)*original.width + (x);
      posN = (y)*novaImage.width + (x);
      pAuxO = parseInt(blue(original.pixels[posO]));
      pAuxN = parseInt(blue(novaImage.pixels[posN]));
      
      if(pAuxO == 255 && pAuxN == 0){        
      //falso negativo
       falsoN ++;
      
      }else if(pAuxO == 0 && pAuxN == 255){
      //falso positivo
      falsoP ++;
      
      }else verdadeiro++;
        
    }
  }
  }else println("IMAGENS DE DIMENSÕES DIFERENTES");
  
  percentFN = falsoN * 100 / count;
  percentFP = falsoP * 100 / count;
  percentV = verdadeiro * 100 / count;
  
  println(count);
  println(falsoN);
  println(falsoP);
  println(verdadeiro);
  println(percentFN);
  println(percentFP);
  println(percentV);
  
  
  
 //for (int i = 0 ;i < m.length; i++){
 //  for (int j = 0; j < m[i].length; j++){
 //    print(m[i][j]); 
 //    } 
 //    println(""); // Aqui é o <enter> 
 //}
  
}


void linhasOrientacao() {
  strokeWeight(1);
  stroke(0);

  //Linhas Horizontais
  for (int i = 0; i <= 300; i+=30) {
    line(0, i, 300, i);
    textSize(10);
    fill(255,0,0);
    text(i, 380, i+10);
  }

  //Linhas Verticais
  for (int i = 0; i <= 400; i+=30) {
    line(i, 0, i, 400);
    textSize(10);
    fill(255,0,0);
    text(i, i+5, 10);
  }
}
