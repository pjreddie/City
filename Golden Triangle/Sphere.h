/*
 *  Sphere.h
 *  Golden Triangle
 *
 *  Not my code!! written by halma at http://www.3dbuzz.com/vbforum/showthread.php?118279-Quick-solution-for-making-a-sphere-in-OpenGL
 */

#define X .525731112119133606 
#define Z .850650808352039932



void normalize(GLfloat *a);

void drawtri(GLfloat *a, GLfloat *b, GLfloat *c, int div, float r);

void drawsphere(int ndiv, float radius);
