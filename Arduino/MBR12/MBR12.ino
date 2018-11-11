

#include <SPI.h>
#include <Wire.h> 
#include <LiquidCrystal_I2C.h>
#include <Keypad.h>
#include<stdlib.h>
#include "Nanoshield_Thermocouple.h"

Nanoshield_Thermocouple thermocouple;

int pinRele1 = A0;
int pinRele2 = A1;

boolean gotAMessage = false; // whether or not you got a message from the client yet
float iTemp1 = 0;
float iTemp2 = 0;

const byte ROWS = 4; //four rows
const byte COLS = 4; //four columns


//define the cymbols on the buttons of the keypads
char hexaKeys[ROWS][COLS] = {
  {
    '1', '2', '3', 'A'
  }
  ,
  {
    '4', '5', '6', 'B'
  }
  ,
  {
    '7', '8', '9', 'C'
  }
  ,
  {
    '*', '0', '#', 'D'
  }
};

byte rowPins[ROWS] = {  
  9, A2, 7, 6}; //connect to the row pinouts of the keypad
byte colPins[COLS] = {  
  5, 4, 3, 2};

//initialize an instance of class NewKeypad
Keypad customKeypad = Keypad( makeKeymap(hexaKeys), rowPins, colPins, ROWS, COLS);

char customKey;


LiquidCrystal_I2C lcd(0x20,16,4);  // set the LCD address to 0x20 for a 16 chars and 2 line display

float contciclo =0;
char BufferKeypad[100];

//Versao do produto
char Versao = '12';
char Release = '1';

char NroSerie[20]  =  "120001001";

//prog_uchar SITE[] PROGMEM = {
char  SITE[80] =  "http://maurinsoft.com";
char AUTOR[100] = "Criado por Marcelo Maurin Martins";
//prog_uchar Produto[] PROGMEM = {
char Produto[10] = {  "MBR12"};

String Mensagem = "maurinsoft.com";

// what our timing resolution should be, larger is better
// as its more 'precise' - but too large and you wont get
// accurate timing
#define RESOLUTION 20

// we will store up to 100 pulse pairs (this is -a lot-)
uint16_t pulses[100][2];  // pair is high and low pulse
uint8_t currentpulse = 0; // index for pulses we're storing

void setup(void) {
  Start_Serial();
  Serial.println("Load firmware....");
  Start_lcd();
  Serial.println("Start outros servicos");
  Start_Reles();
  Start_Thermometro();
  WellCome();

  CLS();
  Imprime(0, Produto);
  Imprime(1, "A suas ordens       ");
  Imprime();
}

void Start_Thermometro()
{
  thermocouple.begin(); 
  // Read thermocouple data
  thermocouple.read();
  iTemp1 = thermocouple.getInternal();
  iTemp2 = thermocouple.getInternal();
}

void Start_Reles()
{
  // initialize the digital pin as an output.
  pinMode(pinRele1, OUTPUT);  
  pinMode(pinRele2, OUTPUT);
  digitalWrite(pinRele1, HIGH);  
  digitalWrite(pinRele2, HIGH);  
  delay(1500);
  digitalWrite(pinRele1, LOW);  
  digitalWrite(pinRele2, LOW);  
}
void Start_lcd()
{
  lcd.init();                      // initialize the lcd 
  lcd.backlight();

}

void Ligar1()
{

  digitalWrite(pinRele1,HIGH);


}

void Desligar1()
{


  digitalWrite(pinRele1,LOW);


}

void Ligar2()
{

  if (digitalRead(pinRele2)==HIGH)
  {
    digitalWrite(pinRele2,LOW);
  }
  else
  {
    digitalWrite(pinRele2,HIGH);
  } 

}

void Desligar2()
{

  digitalWrite(pinRele2,LOW);


}

void CLS()
{
  lcd.clear();
}

//Imprime linha
void Imprime(int y, String Info)
{
  lcd.setCursor(0,y);
  lcd.print(Info);

}
void Le_Teclado()
{
  //Le Teclado
  customKey = customKeypad.getKey();
  if (customKey) {

    if (customKey >= '0' && customKey <= '9')
    {
      sprintf(BufferKeypad, "%s%c", BufferKeypad, customKey);
      //sprintf(BufferKeypad"%s%c",BufferKeypad,customKey);
      //Serial.println(customKey);
      CLS();
      Imprime(0, "KEYBOARD:");
      Imprime(1, BufferKeypad);
      //Sound('d');

    }
    if (customKey == '#') //Limpa Buffer
    {
      sprintf(BufferKeypad, "%s\n", BufferKeypad);
      //BufferKeypad += '\n';
      //Sound('e');
    }
    if (customKey == '*') //Limpa Buffer
    {
      sprintf(BufferKeypad, "");
      //BufferKeypad = "";
      //Sound('f');

      CLS();
      Imprime(0, "KEYBOARD:");
      Imprime(1, BufferKeypad);
      //Sound('a');
    }
    //Macro Funções
    if (customKey == 'A') //LUZ
    {
      sprintf(BufferKeypad, "LUZ\n");
      //BufferKeypad = "LUZ\n";

    }
    //Macro Funções
    if (customKey == 'B') //Abre Porta
    {
      sprintf(BufferKeypad, "TEMP\n");
      //BufferKeypad = "PORTA\n";

    }
    //Macro Funções
    if (customKey == 'C') //TRAVA
    {
      sprintf(BufferKeypad, "LIGAR2\n");
      //BufferKeypad = "TRAVA\n";

    }
    //Macro Funções
    if (customKey == 'D') //LIGAR
    {
      sprintf(BufferKeypad, "LIGAR1\n");


    }
  }
}



void Start_Serial()
{
  Serial.begin(9600);

}


void WellCome()
{
  Serial.println(" ");
  Serial.println("Bem vindo");

  //Serial.println(Empresa);
  Serial.println("MBR12 - Controle de Temperatura");
  Serial.println("Projeto Industrial ETEC");
  Serial.println("https://sourceforge.net/projects/fornoetec/");
  Serial.print("Produto:");  
  Serial.println(Produto);

  Serial.print("Versao:");
  Serial.print(Versao);
  Serial.print(".");
  Serial.println(Release);  

  Serial.print("site:");
  Serial.println(SITE);

  Serial.print("email:");  
  //Serial.println(EMAIL);  

  Serial.println(AUTOR);

  Serial.println(" ");  

}

void Le_Reles()
{
  if (digitalRead(pinRele1)==HIGH)
  { 
    Imprime(2,"Rele 1 Ligado          ");
  }
  else
  {
    Imprime(2,"Rele 1 Desligado       ");
  }
  if (digitalRead(pinRele2)==HIGH)
  { 
    Imprime(3,"Rele 2 Ligado         ");
  }
  else
  {
    Imprime(3,"Rele 2 Desligado     ");
  }

}

void Leituras()
{
  Le_Teclado();
  Le_Serial(); //Le dados do Serial
  Le_Temperatura1();
  Le_Temperatura2();
  Le_Reles();
  KeyCMD();
  if (contciclo>2000)
  {
    //Dht();
    //Le_Led();
    contciclo= 0;
  }
  contciclo++;
}

void Le_Temperatura1()
{
  // Read thermocouple data
  thermocouple.read();

  // Print temperature in the serial port, checking for errors
  // Serial.print("Internal: ");
  // Serial.print(thermocouple.getInternal());
  iTemp1 = thermocouple.getInternal();
  iTemp1=23;

  // Serial.print(" | External: ");
  if (thermocouple.isShortedToVcc()) {
    // Serial.println("Shorted to VCC");
  } 
  else if (thermocouple.isShortedToGnd()) {
    // Serial.println("Shorted to GND");
  } 
  else if (thermocouple.isOpen()) {
    // Serial.println("Open circuit");
  } 
  else {
    // Serial.println(thermocouple.getExternal());
  } 
  char strTemp[16];
  sprintf(strTemp,"Temp F1:%d c   ",iTemp1);
  Imprime(0,strTemp);
}

void Le_Temperatura2()
{
  // Read thermocouple data
  thermocouple.read();

  // Print temperature in the serial port, checking for errors
  // Serial.print("Internal: ");
  // Serial.print(thermocouple.getInternal());
  iTemp2 = thermocouple.getInternal();
  iTemp2=23;

  // Serial.print(" | External: ");
  if (thermocouple.isShortedToVcc()) {
    // Serial.println("Shorted to VCC");
  } 
  else if (thermocouple.isShortedToGnd()) {
    // Serial.println("Shorted to GND");
  } 
  else if (thermocouple.isOpen()) {
    // Serial.println("Open circuit");
  } 
  else {
    // Serial.println(thermocouple.getExternal());
  } 
  char strTemp[16];
  sprintf(strTemp,"Temp F2:%d c   ",iTemp2);
  Imprime(1,strTemp);
}


void ImprimeTemp1()
{
  char strTemp[16];
  sprintf(strTemp,"Temperatura Forno 1:%d c   ",iTemp1);
  Serial.println(strTemp);
}

void ImprimeTemp2()
{
  char strTemp[16];
  sprintf(strTemp,"Temperatura Forno 2:%d c   ",iTemp2);
  Serial.println(strTemp);
}

//Le registro do bluetooth
void Le_Serial()
{  
  char key;
  while(Serial.available()>0) 
  {
    key = Serial.read();

    if(key != 0)
    {
      Serial.print(key);
      //BufferKeypad += key;
      sprintf(BufferKeypad,"%s%c",BufferKeypad,key);
    }
  }   
}



//Comando de entrada do Teclado
void KeyCMD()
{
  bool resp = false;

  //incluir busca /n

  if(strchr (BufferKeypad,'\n')!=0)
  {
    Serial.print("Comando:");
    Serial.println(BufferKeypad);

    if (strcmp( BufferKeypad,"LIGAR2\n")==0)
    {
      Ligar2();
      resp = true;
    }  
    if (strcmp( BufferKeypad,"LIGAR1\n")==0)
    {
      Ligar1();
      resp = true;
    }  
    if (strcmp( BufferKeypad,"DESLIGAR1\n")==0)
    {
      Desligar1();
      resp = true;
    }  

    if (strcmp( BufferKeypad,"DESLIGAR2\n")==0)
    {
      Desligar2();
      resp = true;
    }  

    if (strcmp( BufferKeypad,"LIGAR1\n")==0)
    {
      Ligar1();
      resp = true;
    }  
    if (strcmp( BufferKeypad,"PROGRAMAR\n")==0)
    {
      //RFReceive();
      resp = true;
    }  

    if (strcmp( BufferKeypad,"TEMP1\n")==0)
    {
      ImprimeTemp1();
      resp = true;
    }  
    
    if (strcmp( BufferKeypad,"TEMP2\n")==0)
    {
      ImprimeTemp2();
      resp = true;
    }  


    if (strcmp( BufferKeypad,"MAN\n")==0)
    {    
      Man();
      resp = true;        
    }

    if (resp==false) 
    {
      Serial.print("Comando:");  
      Serial.print(BufferKeypad);  
      Serial.println("Comando nao reconhecido!"); 
      //strcpy(BufferKeypad,'\0');
      memset(BufferKeypad,0,sizeof(BufferKeypad));
    }
    else
    {
      //strcpy(BufferKeypad,'\0');
      memset(BufferKeypad,0,sizeof(BufferKeypad));
    }

    Imprime(); 
    //Imprime(DevSerial);   

  }
}


void Man()
{  
  Serial.println(" "); 
  Serial.println("MAN - manual do equipamento"); 
  Serial.println("AQUECERT:N - Aquecer ate chegar a Temperatura N"); 
  Serial.println("AQUECER:N - Aquecer por N minutos"); 
  Serial.println("LIGAR1 - Ligar Equipamento 1"); 
  Serial.println("LIGAR2 - Ligar Equipamento 2"); 
  Serial.println("DESLIGAR1 - Desligar Equipamento 1"); 
  Serial.println("DESLIGAR2 - Desligar Equipamento 2"); 
  Serial.println("TEMP1 - Le temperatura do forno1");  
  Serial.println("TEMP2 - Le temperatura do forno2");  


}

//Imprime padrão demonstrando entrada de comando
void Imprime()
{
  //Serial.println(" ");
  Serial.print("/>");


}

//Roda as rotinas 
void loop()
{
  Leituras(); 
  //Serial.print(".");
  //delayMicroseconds(1000);
}







