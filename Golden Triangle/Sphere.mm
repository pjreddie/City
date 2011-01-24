/*
 *  Sphere.mm
 *  Golden Triangle
 *
 *  Not my code!! written by halma at http://www.3dbuzz.com/vbforum/showthread.php?118279-Quick-solution-for-making-a-sphere-in-OpenGL
 *
 */

#import "Sphere.h"

static GLfloat vdata[12][3] = {    
    {-X, 0.0, Z}, {X, 0.0, Z}, {-X, 0.0, -Z}, {X, 0.0, -Z},    
    {0.0, Z, X}, {0.0, Z, -X}, {0.0, -Z, X}, {0.0, -Z, -X},    
    {Z, X, 0.0}, {-Z, X, 0.0}, {Z, -X, 0.0}, {-Z, -X, 0.0} 
};
static GLuint tindices[20][3] = { 
    {0,4,1}, {0,9,4}, {9,5,4}, {4,5,8}, {4,8,1},    
    {8,10,1}, {8,3,10}, {5,3,8}, {5,2,3}, {2,7,3},    
    {7,10,3}, {7,6,10}, {7,11,6}, {11,0,6}, {0,1,6}, 
    {6,1,10}, {9,0,11}, {9,11,2}, {9,2,5}, {7,2,11} };

void normalize(GLfloat *a) {
    GLfloat d=sqrt(a[0]*a[0]+a[1]*a[1]+a[2]*a[2]);
    a[0]/=d; a[1]/=d; a[2]/=d;
}

void drawtri(GLfloat *a, GLfloat *b, GLfloat *c, int div, float r) {
    if (div<=0) {
        glNormal3fv(a); glVertex3f(a[0]*r, a[1]*r, a[2]*r);
        glNormal3fv(b); glVertex3f(b[0]*r, b[1]*r, b[2]*r);
        glNormal3fv(c); glVertex3f(c[0]*r, c[1]*r, c[2]*r);
    } else {
        GLfloat ab[3], ac[3], bc[3];
        for (int i=0;i<3;i++) {
            ab[i]=(a[i]+b[i])/2;
            ac[i]=(a[i]+c[i])/2;
            bc[i]=(b[i]+c[i])/2;
        }
        normalize(ab); normalize(ac); normalize(bc);
        drawtri(a, ab, ac, div-1, r);
        drawtri(b, bc, ab, div-1, r);
        drawtri(c, ac, bc, div-1, r);
        drawtri(ab, bc, ac, div-1, r);  //<--Comment this line and sphere looks really cool!
    }  
}

void drawsphere(int ndiv, float radius=1.0) {
    glBegin(GL_TRIANGLES);
    for (int i=0;i<20;i++)
        drawtri(vdata[tindices[i][0]], vdata[tindices[i][1]], vdata[tindices[i][2]], ndiv, radius);
    glEnd();
}

