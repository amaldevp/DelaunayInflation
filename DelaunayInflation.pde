import org.processing.wiki.triangulate.*;
ArrayList<PVector> points = new ArrayList<PVector>();
ArrayList triangles = new ArrayList();
PrintWriter output;
import quickhull3d.QuickHull3D;
PImage im,im1;
int[][] pts=new int[10000][2];
int pc=0;
float[][] tr=new float[10000][6];
int trc=0;
void draw()
{
}
double area(float x1,float y1,float x2,float y2,float x3,float y3)
{
  return abs((x2-x1)*(y3-y1)-(x3-x1)*(y2-y1));
}
float[] circumcenter(float a0,float a1,float b0,float b1,float c0,float c1)
{
  float[] p=new float[2];
  float D= 2*( a1*c0 + b1*a0 - b1*c0 -a1*b0 -c1*a0 + c1*b0 );
  p[0] =( b1*sq(a0)- c1*sq(a0)- sq(b1)*a1 + sq(c1)*a1 + sq(b0)*c1 + sq(a1)*b1  + sq(c0)*a1 - sq(c1)*b1 - sq(c0)*b1 - sq(b0)*a1 + sq(b1)*c1 - sq(a1)*c1) / D;
  
  p[1] =( sq(a0)*c0+ sq(a1)*c0 + sq(b0)*a0 - sq(b0) *c0 + sq(b1) *a0 - sq(b1) *c0 - sq(a0) *b0 - sq(a1) *b0 - sq(c0) *a0 + sq(c0) *b0 - sq(c1) *a0 + sq(c1) *b0)/D;
  return p;
  
}
void setup()
{
   output = createWriter("positions.stl"); 
 output.println("solid name");
  im=loadImage("path825.png");
  
  size(1000,1800,P3D);
  background(255);
  for(int i=0;i<im.width;i++)
  for(int j=0;j<im.height;j++)
  if(red(im.get(i,j))>200)
  im.set(i,j,color(255));
  else
  im.set(i,j,color(0));
  for(int i=1;i<im.width-1;i++)
  for(int j=1;j<im.height-1;j++)
  if(im.get(i,j)==color(0))
  {
  if(im.get(i-1,j-1)==color(255)||red(im.get(i-1,j))>200||
    red(im.get(i-1,j+1))>200||red(im.get(i,j-1))>200||
    red(im.get(i,j+1))>200||red(im.get(i+1,j-1))>200||
    red(im.get(i+1,j))>200||red(im.get(i+1,j+1))>200)
    im.set(i,j,color(0,255,0));
    else
    im.set(i,j,color(0,0,255));
  }

//im.save("dots1.png");
  for(int i=0;i<im.width;i++)
  for(int j=0;j<im.height;j++)
  {
    if(im.get(i,j)==color(0,255,0))
   {
      for(int k1=-1;k1<2;k1++)
      for(int k2=-1;k2<2;k2++)
      {
      if(im.get(i+k1,j+k2)==color(0,255,0)&&(k1!=0||k2!=0))
      {
   //     print((i+k1)+" "+(j+k2)+" ");
      im.set(i+k1,j+k2,color(0,0,255));
      }
      }
    }
  }
  background(255);
  for(int i=1;i<im.width-1;i++)
  for(int j=1;j<im.height-1;j++)
  if(im.get(i,j)!=color(0,255,0))
{}
  else
  {
    pts[pc][0]=i;
    pts[pc][1]=j;
    pc++;
  }
  image(im,0,0);
  for(int i = 0 ; i < pc ; i++){
          points.add(new PVector(pts[i][0],pts[i][1]));
     }
  triangles = Triangulate.triangulate(points);
  background(255);
     for (int i = 0; i < triangles.size(); i++) {
          Triangle t = (Triangle) triangles.get(i);
       {
              float[] cc=new float[2];
            cc=circumcenter(t.p1.x,t.p1.y,t.p2.x,t.p2.y,t.p3.x,t.p3.y);
            if(im.get((int)cc[0],(int)cc[1])!=color(255)&&cc[0]>0&&cc[0]<im.width&&cc[1]>0&&cc[1]<im.height)
            {
            //  fill(255,255,0);
              triangle(t.p1.x*2,t.p1.y*2,t.p2.x*2,t.p2.y*2,t.p3.x*2,t.p3.y*2);
          //    line(t.p3.x,t.p3.y,t.p2.x,t.p2.y);
              tr[trc][0]=t.p1.x;
              tr[trc][1]=t.p1.y;
              tr[trc][2]=t.p2.x;
              tr[trc][3]=t.p2.y;
              tr[trc][4]=t.p3.x;
              tr[trc][5]=t.p3.y;
              trc++;
            }
            }
     }
     for(int i=0;i<trc;i++)
     {
       ArrayList<PVector> subp = new ArrayList<PVector>();
       ArrayList subt = new ArrayList();
       float[][] sd1= new float[9][2];
       float[][] sd2= new float[9][2];
       float[][] sd3= new float[9][2];
       float[][] sd=new float[24][2];
       int sdc=0;
       {
       if(distance(tr[i][0],tr[i][1],tr[i][2],tr[i][3])>14)
       {
         sd1=subdivide(tr[i][0],tr[i][1],tr[i][2],tr[i][3]);
              for(int k=2;k<9;k++,sdc++)
       sd[sdc]=sd1[k];
       }
       if(distance(tr[i][0],tr[i][1],tr[i][4],tr[i][5])>14)
       {
       sd2=subdivide(tr[i][0],tr[i][1],tr[i][4],tr[i][5]);
       for(int k=2;k<9;k++,sdc++)
       sd[sdc]=sd2[k];
       }
       if(distance(tr[i][2],tr[i][3],tr[i][4],tr[i][5])>14)
       {
       sd3=subdivide(tr[i][2],tr[i][3],tr[i][4],tr[i][5]);
        for(int k=2;k<9;k++,sdc++)
       sd[sdc]=sd3[k];
       }
       if(sdc>5)
       {
       sd[sdc][0]=tr[i][0];
       sd[sdc++][1]=tr[i][1];
       sd[sdc][0]=tr[i][2];
       sd[sdc++][1]=tr[i][3];
       sd[sdc][0]=tr[i][4];
       sd[sdc++][1]=tr[i][5];
       float[][] newp=new float[sdc][2];
       for(int k=0;k<sdc;k++)
       newp[k]=sd[k];
       double qPoints[] = new double[ sdc*3 + 9 ];
  for(int k=0; k<sdc; k++)
  {
    qPoints[k*3] = newp[k][0];
    qPoints[k*3+1] = newp[k][1];
    qPoints[k*3+2] = -(newp[k][0]*newp[k][0] + newp[k][1]*newp[k][1]); // standard half-squared eucledian distance
  }
  qPoints[ qPoints.length-9 ] = -2000;
  qPoints[ qPoints.length-8 ] = 0;
  qPoints[ qPoints.length-7 ] = -4000000;
  qPoints[ qPoints.length-6 ] = 2000;
  qPoints[ qPoints.length-5 ] = 2000;
  qPoints[ qPoints.length-4 ] = -8000000;
  qPoints[ qPoints.length-3 ] = 2000;
  qPoints[ qPoints.length-2 ] = -2000;
  qPoints[ qPoints.length-1 ] = -8000000;
  QuickHull3D quickHull = new QuickHull3D(qPoints);
  quickHull.triangulate();
  int[][] faces = quickHull.getFaces(QuickHull3D.POINT_RELATIVE + QuickHull3D.CLOCKWISE);
  float[][] inf=new float[100000][3];
  int infi=0;
  for (int k = 0; k < faces.length; k++)
  {
    infi=0;
    int pi=0;
    float[][] tp=new float[10][2];
     for (int j = 0; j< faces[k].length; j++)
     {
        int pt = faces[k][j];
        if ( pt < sdc)
        {
          tp[pi][0]=newp[pt][0];
          tp[pi][1]=newp[pt][1];
          inf[infi][0]=tp[pi][0];
          inf[infi][1]=tp[pi][1];
          double d1,d2,d3;
          d1=finddistance(tp[pi][0],tp[pi][1],tr[i][0],tr[i][1],tr[i][2],tr[i][3]);
           d2=finddistance(tp[pi][0],tp[pi][1],tr[i][4],tr[i][5],tr[i][2],tr[i][3]);
            d3=finddistance(tp[pi][0],tp[pi][1],tr[i][0],tr[i][1],tr[i][4],tr[i][5]);
            if((d1==0&&d2==0)||(d2==0&&d3==0)||(d1==0&&d3==0))
            {
              inf[infi][2]=0;
            }
            else
          if(d1<d2&&d1<d3)
          {
            inf[infi][2]=sqrt(sq((float)distance(tr[i][0],tr[i][1],tr[i][2],tr[i][3])/2)-sq((float)distance(tp[pi][0],tp[pi][1],(tr[i][0]+tr[i][2])/2,(tr[i][1]+tr[i][3])/2)));
          }
          else
          if(d2<d1&&d2<d3)
          {
            inf[infi][2]=sqrt(sq((float)distance(tr[i][4],tr[i][5],tr[i][2],tr[i][3])/2)-sq((float)distance(tp[pi][0],tp[pi][1],(tr[i][4]+tr[i][2])/2,(tr[i][5]+tr[i][3])/2)));
          }
          else
          if(d3<d1&&d3<d2)
          {
            inf[infi][2]=sqrt(sq((float)distance(tr[i][0],tr[i][1],tr[i][4],tr[i][5])/2)-sq((float)distance(tp[pi][0],tp[pi][1],(tr[i][0]+tr[i][4])/2,(tr[i][1]+tr[i][5])/2)));
          }
          else
          println("Errrrooororororr"+" "+d1+" "+d2+" "+d3);
          infi++;
        }
     }
if(infi==3)
{
beginShape(TRIANGLE);
vertex(2*inf[0][0],2*inf[0][1],0);
vertex(2*inf[1][0],2*inf[1][1],0);
vertex(2*inf[2][0],2*inf[2][1],0);
endShape(CLOSE);
float x1,x2,x3,y1,y2,y3,z1,z2,z3;
x1=inf[0][0];
x2=inf[1][0];
x3=inf[2][0];
y1=inf[0][1];
y2=inf[1][1];
y3=inf[2][1];
if(((x2-x1)*(y3-y1)-(y2-y1)*(x3-x1))>((x3-x1)*(y2-y1)-(y3-y1)*(x2-x1)))
{
output.println("facet normal 0 0 0");
   output.println("outer loop");
        output.println("vertex"+" "+inf[0][0]+" "+inf[0][1]+" "+inf[0][2]);
        output.println("vertex"+" "+inf[1][0]+" "+inf[1][1]+" "+inf[1][2]);
                output.println("vertex"+" "+inf[2][0]+" "+inf[2][1]+" "+inf[2][2]);
  output.println("endloop");
output.println("endfacet");
output.println("facet normal 0 0 0");
   output.println("outer loop");
           output.println("vertex"+" "+inf[1][0]+" "+inf[1][1]+" "+(-inf[1][2]));
        output.println("vertex"+" "+inf[0][0]+" "+inf[0][1]+" "+(-inf[0][2]));
                output.println("vertex"+" "+inf[2][0]+" "+inf[2][1]+" "+(-inf[2][2]));
  output.println("endloop");
output.println("endfacet");
}
else
if(((x2-x1)*(y3-y1)-(y2-y1)*(x3-x1))<((x3-x1)*(y2-y1)-(y3-y1)*(x2-x1)))
{
  output.println("facet normal 0 0 0");
   output.println("outer loop");
        output.println("vertex"+" "+inf[0][0]+" "+inf[0][1]+" "+inf[0][2]);
        output.println("vertex"+" "+inf[2][0]+" "+inf[2][1]+" "+inf[2][2]);
        output.println("vertex"+" "+inf[1][0]+" "+inf[1][1]+" "+inf[1][2]);
                
  output.println("endloop");
output.println("endfacet");
output.println("facet normal 0 0 0");
   output.println("outer loop");
           output.println("vertex"+" "+inf[1][0]+" "+inf[1][1]+" "+(-inf[1][2]));
             output.println("vertex"+" "+inf[2][0]+" "+inf[2][1]+" "+(-inf[2][2]));
        output.println("vertex"+" "+inf[0][0]+" "+inf[0][1]+" "+(-inf[0][2]));
              
  output.println("endloop");
output.println("endfacet");
}
}
  }
   }  
     }
     }
output.println("endsolid name");
output.flush();
output.close();
//save("subdel.png");
}

int pc1=0;
double finddistance(float px,float py, float vx1,float vy1,float vx2,float vy2)
{
  double d,d1,d2;
  double t=-((vx1-px)*(vx2-vx1)+(vy1-py)*(vy2-vy1))/(sq(vx2-vx1)+sq(vy2-vy1));
  if(t>=0&&t<=1)
  {
    d=abs((vx2-vx1)*(vy1-py)-(vy2-vy1)*(vx1-px))/sqrt(sq(vx2-vx1)+sq(vy2-vy1));
    return d;
  }
  else
  {
    d1=sqrt(sq(vx2-px)+sq(vy2-py));
    d2=sqrt(sq(vx1-px)+sq(vy1-py));
    if(d1<d2)
    return d1;
    else
    return d2;
  }
}
  int sf=1;
  double distance(float a,float b,float c,float d)
  {
    return sqrt(sq(c-a)+sq(d-b));
  }
float[][] subdivide(float a,float b,float c,float d)
{
  a=a*sf;
  b=b*sf;
  c=c*sf;
  d=d*sf;
  float[][] sub=new float[10][2];
  sub[0][0]=a;
  sub[0][1]=b;
  sub[1][0]=c;
  sub[1][1]=d;
 sub[2][0]=(sub[0][0]+sub[1][0])/2;
  sub[2][1]=(sub[0][1]+sub[1][1])/2;
   sub[3][0]=(sub[0][0]+sub[2][0])/2;
  sub[3][1]=(sub[0][1]+sub[2][1])/2;
   sub[4][0]=(sub[2][0]+sub[1][0])/2;
  sub[4][1]=(sub[2][1]+sub[1][1])/2;
   sub[5][0]=(sub[0][0]+sub[3][0])/2;
  sub[5][1]=(sub[0][1]+sub[3][1])/2;
   sub[6][0]=(sub[2][0]+sub[3][0])/2;
  sub[6][1]=(sub[2][1]+sub[3][1])/2;
   sub[7][0]=(sub[2][0]+sub[4][0])/2;
  sub[7][1]=(sub[2][1]+sub[4][1])/2;
   sub[8][0]=(sub[4][0]+sub[1][0])/2;
  sub[8][1]=(sub[4][1]+sub[1][1])/2;
  return sub;
}
