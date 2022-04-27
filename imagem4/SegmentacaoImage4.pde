void setup() {
  size(1200, 640);
  noLoop();
}

void draw() {
  PImage img = loadImage("img4.jpg");
  PImage imgMask = loadImage("img4 - mask.png");
  PImage aux = loadImage("img4.jpg");
  PImage aux2 = createImage(img.width, img.height, RGB);
 
   //blur
   int jan = 0; 
   
     //aux3 = filtroMediaColoridoJanela(aux3, jan);// Faz o filtro de Media, para desfocar a imagem e depois utiliza faz uma media de cada canal(RGB),para deixar mais facil de identificar o que é preto e o que nao é
     //aux3 = realcarCor(aux3,255); //Faz a saturação de todos os pixels proximo ao 0, para deixar mais evidente e facilitar a identificação
    //aux3 = filtroEscalaCinza(aux3, aux3);// Aplica o filtro de cinza, para facilitar na limiarização
    
   // aux = filtroMediaColoridoJanela(aux, jan);// Faz o filtro de Media, para desfocar a imagem e depois utiliza faz uma media de cada canal(RGB),para deixar mais facil de identificar o que é preto e o que nao é
    aux = realcarCor(aux,255); //Faz a saturação de todos os pixels proximo ao 0, para deixar mais evidente e facilitar a identificação
    aux = filtroEscalaCinza(aux, aux);// Aplica o filtro de cinza, para facilitar na limiarização
   aux = limiarizar(aux);// Efetua a limiarização com base no tom preto dentro de uma janela centralizada no cachorro   
      
   verificarPixel(imgMask,aux);// Faz a contagem de do Falso Positivo, Falso Negativo, Positivo e %
   aux2 = addImageNoG(aux,aux2,img);// Substitui os pixels brancos pelos pixels da imagem original cachorro na imagem com o fundo preto
   
  image(img,0,0);//Imagem original
  
  image(imgMask,0,imgMask.height + 10);//Imagem grounth true original
  image(aux,(aux.width)+10,0);//Imagem G nossa  
  image(aux2,(aux2.width*2)+20,0);// Imagem G com o cachorro
  //linhasOrientacao();
}


//limiariraz
PImage limiarizar(PImage aux2){    
   int rx[] = {45,260};
   int ry[] = {85,270};
   for (int y = 0; y < aux2.height; y++) {
    for (int x = 0; x < aux2.width; x++) {
      int pos = (y)*aux2.width + (x);
      if((blue(aux2.pixels[pos]) < 10) && (x>rx[0] && x < rx[1] && y > ry[0] && y < ry[1]))  
          aux2.pixels[pos] = color(255);
      else aux2.pixels[pos] = color(0);      
    }
  }
  return aux2;
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

//escala cinza
//transforma a imagem em escala de cinza
PImage filtroEscalaCinza(PImage aux, PImage img){
    for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {

      int pos = (y)*img.width + (x);
      int media = int(green(img.pixels[pos]));
      aux.pixels[pos] = color(media);
    }
  }
  return aux;
}

PImage filtroMediaColoridoJanela(PImage aux,int jan){
    // Filtro de Média com Janela Deslizante
  for (int y = 0; y < aux.height; y++) {
    for (int x = 0; x < aux.width; x++) {
      //int jan = 9;
      int pos = y*aux.width + x; /* acessa o ponto em forma de vetor */

      float mediar = 0;
      float mediag = 0;
      float mediab = 0;
      int qtde = 0;

      for (int i = jan*(-1); i <= jan; i++) {
        for (int j = jan*(-1); j <= jan; j++) {
          int disy = y+i;
          int disx = x+j;
          if (disy >= 0 && disy < aux.height &&
            disx >= 0 && disx < aux.width) {
            int pos_aux = disy * aux.width + disx;
            float r = red(aux.pixels[pos_aux]);
            float g = green(aux.pixels[pos_aux]);
            float b = blue(aux.pixels[pos_aux]);
            mediar += r;
            mediag += g;
            mediab += b;
            qtde++;
          }
        }
      }
      mediar = mediar / qtde;
      mediag = mediag / qtde;
      mediab = mediab / qtde;
      
      aux.pixels[pos] = color(mediar,mediag,mediab);
    }
  }
  
  return aux;
}

PImage realcarCor(PImage aux, int qtd){
    // Filtro de Média com Janela Deslizante
  for (int y = 0; y < aux.height; y++) {
    for (int x = 0; x < aux.width; x++) {
      
      int pos = y*aux.width + x; /* acessa o ponto em forma de vetor */       
      float ri = red(aux.pixels[pos]);
      float gi = green(aux.pixels[pos]);
      float bi = blue(aux.pixels[pos]);
      
      if(gi < 130){ // realcar cores que estão abaixo de 130 no canal verde
        if(gi - qtd < 0)gi = 0;
        if(ri - qtd < 0)ri = 0;
        if(bi - qtd < 0)bi = 0;        
        
          aux.pixels[pos] = color(ri,gi, bi);  
      }
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
   
  float falsoN1 = falsoN * 100;
  percentFN = falsoN1/count;
  println("Falso Negativo \n Quantidade:"+falsoN+" \n Porcentagem:"+percentFN+"\n("+falsoN+" x "+100 +")/"+count+ " = "+ percentFN);
  
  
  println("");
  float falsoP1 = falsoP * 100;  
  percentFP = falsoP1 / count;
  println("Falso Positivo \n Quantidade:"+falsoP+" \n Porcentagem:"+percentFP+"\n("+falsoP+" x "+100 +")/"+count+ " = "+ percentFP);
  
  println("");
  float percentV1 = verdadeiro * 100;  
  percentV = percentV1 / count;
  println("Verdadeiro \n Quantidade:"+verdadeiro+" \n Porcentagem:"+percentV+"\n("+verdadeiro+" x "+100 +")/"+count+ " = "+ percentV); 
}


void linhasOrientacao() {
  strokeWeight(1);
  stroke(0);

  //Linhas Horizontais
  for (int i = 0; i <= 300; i+=20) {
    line(0, i, 360, i);
    stroke(255,0,0);
    textSize(10);
    fill(255,0,0);
    text(i, 300, i+10);
  }

  //Linhas Verticais
  for (int i = 0; i <= 400; i+=20) {
    line(i, 0, i, 300);
    stroke(255,0,0);
    textSize(10);
    fill(255,0,0);
    text(i, i+5, 10);
  }
}
