void setup() {
  size(1200, 640);
  noLoop();
}

void draw() {
  PImage img = loadImage("img5.jpg");
  PImage imgMask = loadImage("img5 - mask.png");
  PImage aux = loadImage("img5.jpg");
  PImage aux2 = createImage(img.width, img.height, RGB);
 
   //blur
   int jan = 1; 
    aux = filtroMediaColoridoJanela2(aux,jan);// Primeiro filtro aplicando igualando os tons de azul e vermelho deixa a imagem mais fria
    aux = filtroMediaColoridoJanela(aux, jan);// Faz o filtro de Media, para desfocar a imagem e depois utiliza faz uma media de cada canal(RGB)    
    aux = limiarizarDiff(aux);//Deixa todos os pixels que possuem o canal de verde - o canal azul > 20 e também os pixels aonde o verde está acima de 99
    aux = limiarizar(aux); // Limiariza o resto da imagem e também remove alguns pixels que ficaram sobrando atraves de recorte
    
    
    
   verificarPixel(imgMask,aux);// Faz a contagem de do Falso Positivo, Falso Negativo, Positivo e %
   aux2 = addImageNoG(aux,aux2,img);// Substitui os pixels brancos pelos pixels da imagem original cachorro na imagem com o fundo preto
   
  image(img,0,0);//Imagem original
  
  //image(aux2,0,0);// Imagem G com o cachorro
  image(imgMask,0,imgMask.height + 10);//Imagem grounth true original
  image(aux,(aux.width)+10,0);//Imagem G nossa
  image(aux2,(aux2.width*2)+20,0);// Imagem G com o cachorro
}

//limiariraz
PImage limiarizarGreen(PImage aux2){   
   for (int y = 0; y < aux2.height; y++) {
    for (int x = 0; x < aux2.width; x++) {
      int pos = (y)*aux2.width + (x);
      if((green(aux2.pixels[pos]) <130))  
          aux2.pixels[pos] = color(0);
      else aux2.pixels[pos] = color(255);      
    }
  }
  return aux2;
}

//Verifica a faixa de cores, a diferença entre os canais Verde - Canal Azul, se for menor que 20 ou se o canal verde ultrapassa 90 - deixa em preto

PImage limiarizarDiff(PImage img){  
   //cara x = 160 240  y = 60 120
   for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      int pos = (y)*img.width + (x);
      float g = green(img.pixels[pos]);
      float b = blue(img.pixels[pos]);
      
      if((g-b >20) || g <99 )  img.pixels[pos] = color(0);   
    }
  }
  return img;
}

//limiariraz
PImage limiarizar(PImage aux2){    
   int rx[] = {95,260};
   int ry[] = {30,250}; 
   int rcx[] = {160,240};
   int rcy[] = {60,120};   
   int rtx[] = {140,240};
   int rty[] = {30,45};
   
   for (int y = 0; y < aux2.height; y++) {
    for (int x = 0; x < aux2.width; x++) {
      int pos = (y)*aux2.width + (x);
      
      if(x >= rcx[0] && x<=rcx[1] && y >= rcy[0] && y <=rcy[1])aux2.pixels[pos] = color(255); 
      if(x >= rx[0] && x<=rx[1] && y<=ry[1] ){
        if(blue(aux2.pixels[pos]) > 50)aux2.pixels[pos] = color(255);
      }
      else aux2.pixels[pos] = color(0);       
     if(y < 30){
      if((blue(aux2.pixels[pos]) > 50 && x>rtx[0] && x<rtx[1] && y>rty[0] && y<rty[1]))aux2.pixels[pos] = color(0,0,255);
      else aux2.pixels[pos] = color(0);
     }     
     
     //retirando alguns pontos indesejados
     if(blue(aux2.pixels[pos]) > 50 && x >60 && x <160 && y >0 && y < 55)aux2.pixels[pos] =color(0);     
     if(blue(aux2.pixels[pos]) > 50 && x >225 && x <260 && y >20 && y < 40)aux2.pixels[pos] =color(0);        
     if((blue(aux2.pixels[pos]) > 50) && (( x >233 && x <280) && (y >0 && y < 50)|| ( x >140 && x <179) && (y > 20 && y < 38)))aux2.pixels[pos] =color(0);
     
     
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
            float r = blue(aux.pixels[pos_aux]);
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

PImage filtroMediaColoridoJanela2(PImage aux,int jan){
    // Filtro de Média com Janela Deslizante
  for (int y = 0; y < aux.height; y++) {
    for (int x = 0; x < aux.width; x++) {
      //int jan = 9;
      int pos = y*aux.width + x; /* acessa o ponto em forma de vetor */

      float mediar = 0;
      int qtde = 0;

      for (int i = jan*(-1); i <= jan; i++) {
        for (int j = jan*(-1); j <= jan; j++) {
          int disy = y+i;
          int disx = x+j;
          if (disy >= 0 && disy < aux.height &&
            disx >= 0 && disx < aux.width) {
            int pos_aux = disy * aux.width + disx;
            float r = blue(aux.pixels[pos_aux]);
            mediar += r;
            qtde++;
          }
        }
      }
      mediar = mediar / qtde;      
      aux.pixels[pos] = color(mediar,green(aux.pixels[pos]),blue(aux.pixels[pos]));
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
    line(0, i, 300, i);
    stroke(255,0,0);
    textSize(10);
    fill(255,0,0);
    text(i, 380, i+10);
  }

  //Linhas Verticais
  for (int i = 0; i <= 400; i+=20) {
    line(i, 0, i, 400);
    stroke(255,0,0);
    textSize(10);
    fill(255,0,0);
    text(i, i+5, 10);
  }
}
