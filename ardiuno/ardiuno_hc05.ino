int deg=0;
 int dist=0;
int a;
int i=0;
int arr[3];
void setup()
{
Serial.begin(9600);
}
void loop()
{
  //Serial.flush();
  if(Serial.available()>0)
  {
      a=Serial.read();
      if(a==255)
{ 
dist=arr[0];
deg=arr[1]+arr[2];
Serial.println( deg);
Serial.println(dist);
i=0;
}
else{
arr[i]=a;
i++;
}
     

  }
  //Serial.flush();
  //delay(200);
}
