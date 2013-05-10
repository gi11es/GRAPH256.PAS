{$G+}   { Jeu d'instructions 80286 … utiliser. }
Unit Graph256;

                   {     Kouiskas, 19/5/99 -> 30/4/00     }
                   {     Unit‚ de mode 13h 320*200*256    }
                   {           Sous license GPL           }

{****************************************************************************}
                                    INTERFACE
{****************************************************************************}

Uses dos; { Pour le nombre d'images par seconde }

Type
  Pbyte = ^byte; { Le tampon est un pointeur sur le type byte }
  Palette = array[0..767] of byte; { type palette de couleur }
  Sprite = ^_Spr;
  _Spr = array [0..319,0..199] of byte;

Var
  _Buffer: PByte;  { Tampon m‚moire }
  _Style, _Couleur: Byte; { Variables globales }
  _Fontspr: Sprite;
  _Fps, _Images, _Sc: word;
  _BoolFps: boolean;
  _ReadKey: char;
  _CurrentPalette: palette;

Const   { Palette d'origine }
  _palette:palette=(0,0,0,0,0,42,0,42,0,0,42,42,42,0,0,42,0,42,42,21,0,
  42,42,42,21,21,21,21,21,63,21,63,21,21,63,63,63,21,21,63,21,63,63,63,
  21,63,63,63,0,0,0,5,5,5,8,8,8,11,11,11,14,14,14,17,17,17,20,20,20,24,
  24,24,28,28,28,32,32,32,36,36,36,40,40,40,45,45,45,50,50,50,56,56,56,
  63,63,63,0,0,63,16,0,63,31,0,63,47,0,63,63,0,63,63,0,47,63,0,31,63,0,
  16,63,0,0,63,16,0,63,31,0,63,47,0,63,63,0,47,63,0,31,63,0,16,63,0,0,
  63,0,0,63,16,0,63,31,0,63,47,0,63,63,0,47,63,0,31,63,0,16,63,31,31,63,
  39,31,63,47,31,63,55,31,63,63,31,63,63,31,55,63,31,47,63,31,39,63,31,
  31,63,39,31,63,47,31,63,55,31,63,63,31,55,63,31,47,63,31,39,63,31,31,
  63,31,31,63,39,31,63,47,31,63,55,31,63,63,31,55,63,31,47,63,31,39,63,
  45,45,63,49,45,63,54,45,63,58,45,63,63,45,63,63,45,58,63,45,54,63,45,
  49,63,45,45,63,49,45,63,54,45,63,58,45,63,63,45,58,63,45,54,63,45,49,
  63,45,45,63,45,45,63,49,45,63,54,45,63,58,45,63,63,45,58,63,45,54,63,
  45,49,63,0,0,28,7,0,28,14,0,28,21,0,28,28,0,28,28,0,21,28,0,14,28,0,
  7,28,0,0,28,7,0,28,14,0,28,21,0,28,28,0,21,28,0,14,28,0,7,28,0,0,28,
  0,0,28,7,0,28,14,0,28,21,0,28,28,0,21,28,0,14,28,0,7,28,14,14,28,17,
  14,28,21,14,28,24,14,28,28,14,28,28,14,24,28,14,21,28,14,17,28,14,14,
  28,17,14,28,21,14,28,24,14,28,28,14,24,28,14,21,28,14,17,28,14,14,28,
  14,14,28,17,14,28,21,14,28,24,14,28,28,14,24,28,14,21,28,14,17,28,20,
  20,28,22,20,28,24,20,28,26,20,28,28,20,28,28,20,26,28,20,24,28,20,22,
  28,20,20,28,22,20,28,24,20,28,26,20,28,28,20,26,28,20,24,28,20,22,28,
  20,20,28,20,20,28,22,20,28,24,20,28,26,20,28,28,20,26,28,20,24,28,20,
  22,28,0,0,16,4,0,16,8,0,16,12,0,16,16,0,16,16,0,12,16,0,8,16,0,4,16,
  0,0,16,4,0,16,8,0,16,12,0,16,16,0,12,16,0,8,16,0,4,16,0,0,16,0,0,16,
  4,0,16,8,0,16,12,0,16,16,0,12,16,0,8,16,0,4,16,8,8,16,10,8,16,12,8,16,
  14,8,16,16,8,16,16,8,14,16,8,12,16,8,10,16,8,8,16,10,8,16,12,8,16,14,
  8,16,16,8,14,16,8,12,16,8,10,16,8,8,16,8,8,16,10,8,16,12,8,16,14,8,
  16,16,8,14,16,8,12,16,8,10,16,11,11,16,12,11,16,13,11,16,15,11,16,16,
  11,16,16,11,15,16,11,13,16,11,12,16,11,11,16,12,11,16,13,11,16,15,11,
  16,16,11,15,16,11,13,16,11,12,16,11,11,16,11,11,16,12,11,16,13,11,16,
  15,11,16,16,11,15,16,11,13,16,11,12,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0);

Procedure Init256; { A mettre au d‚but de chacun de vos programmes }
Procedure Close256; { A mettre … la fin de chacun de vos programmes }
Procedure Clear(couleur : byte); { Efface tout l'‚cran virtuel }
Procedure Refresh; { Affiche tout en synchronisant avec l'‚cran }
Procedure PutPixel(x,y: integer ; couleur: byte); { Allume un pixel }
Function  GetPixel(x,y: integer):byte; { Renvoie la couleur d'un pixel }
Procedure Setcolor(x: byte); { Choisit la couleur de dessin courante }
Procedure SetFps(b: boolean); { Choisit d'affichet le nombre d'images par sec}
Procedure Line(x1,y1,x2,y2: integer); { Dessine une ligne }
Procedure Circle(x,y,r: integer); { Dessine un cercle }
Procedure Rectangle(x1,y1,x2,y2: integer); { Dessine un rectangle }
Procedure Triangle(x1,y1,x2,y2,x3,y3: integer);{ Dessine un triangle }
Procedure Quadri(x1,y1,x2,y2,x3,y3,x4,y4: integer); { Dessine un quadrilatŠre}
Procedure SetStyle(x: byte); { Style de remplissage }
Procedure SetRGBPalette(Num, R, G, B: Byte); { Change une couleur de palette }
Procedure OutChar(x,y: integer; coul: byte; car: char); { Ecrire caractŠre }
Procedure OutText(x,y: integer; texte: string); { Ecrire chaŒne }
Procedure SaveSprite(fto: string; x1,y1,x2,y2: integer); { Sauve un sprite }
Procedure AffSprite(var spr: sprite; x1,y1,x2,y2: integer);
Procedure LoadSprite(fto: string; x1,y1,x2,y2: integer; var spr: sprite);
Procedure CloseSprite(var spr: sprite);
Procedure ChargePCX(nomfichier : string; var destination: Pbyte; var Palette : Palette);
Procedure PcxToSpr(ifile,ofile: string); { Convertisseur PCX -> SPR }
Function  IntToStr(I: longint): String;
Function  Get(x,y: integer; truc: sprite):byte; { getpixel dans un sprite }
Procedure Put(x,y: integer ; couleur: byte; truc: sprite); { putpixel }

{****************************************************************************}
                                  IMPLEMENTATION
{****************************************************************************}

Procedure Init256; { Initialise le mode 13h }
Begin
  asm
    mov ax,13h     { Ax=13h }
    int 10h        { Appel de l'interruption 10h : tout ce qui est graphique }
  end;
  getmem(_buffer,64400); { Alloue 64400 octets de m‚moire pour le buffer }
  loadsprite('font.spr',0,0,319,199,_fontspr);
  _BoolFps:=false;
  _currentpalette:=_palette;
End;

Procedure Close256; { Revient au mode texte et vide la m‚moire }
Begin
  asm
    mov ax,3        { Ax=3 }
    int 10h         { Retour au mode texte (Ax=3) via l'interruption 10h }
  end;
  closesprite(_fontspr);
  freemem(_buffer,64400); { LibŠre la m‚moire allou‚e pour le buffer }
End;

Procedure Clear(couleur : byte); assembler; { Efface tout l'‚cran virtuel }
Asm
  les di, _buffer
  mov cx, 16000
  db $66, $33, $DB        { xor ebx,ebx }
  mov bl, couleur
  mov bh, bl
  mov ax, bx
  db $66, $C1, $E0, $10   { shl eax, 16 }
  db $66, $03, $C3        { add eax, ebx }
  db $F3, $66, $AB        { rep stosd }
End;

Procedure Refresh; { Affiche tout en synchronisant avec l'‚cran }
Var
  h,m,s,c,dif: word;
Begin
  if _BoolFps then
  begin
    gettime(h,m,s,c);
    if _sc>c then dif:=100-_sc+c else dif:=c-_sc;
    if dif>50 then
    begin
      _fps:=round(100/(dif)*_images);
      _sc:=c;
      _images:=0;
    end;
    outtext(10,10,inttostr(_fps)+' fps');
    inc(_images);
  end;
  asm
  @Sync_Boucle1:           { Le principe est le suivant: pour synchroniser  }
    mov DX, 3dah           { l'affichage, l'‚cran renvoie un signal lorsque }
    in AL, DX              { l'‚lectron est en fin de parcours (en bas …    }
    test AL, 8             { droite de l'‚cran). De cette maniŠre, on attend}
    jne @Sync_Boucle1      { un peu pour que le canon … ‚lectrons soit de   }
  @Sync_Boucle2:           { nouveau point‚ en haut … gauche de l'‚cran et  }
    in AL, DX              { on copie le tampon m‚moire vers la m‚moire     }
    test AL, 8             { graphique, l'‚change se faisant de m‚moire …   }
    jz @Sync_Boucle2       { m‚moire, c'est trŠs rapide. De cette maniŠre,  }
                           { l'‚cran re‡oit toujours les informations au bon}
    push ds                { moment et le clignotement trŠs d‚sagr‚able que }
    lds si, _buffer        { l'on trouvait en faisant de l'affichage rapide }
    mov ax, 0A000h         { avec l'unit‚ Graph a disparu.                  }
    mov es, ax
    xor di, di
    mov cx, 16000
    db $66, $F3, $A5       { rep movsd }
    pop ds
  end;
End;

Procedure PutPixel(x,y: integer ; couleur: byte); assembler; { Allume pixel }
Asm
  les di, _buffer          { buffer[y*320+x]:=couleur }
  mov ax, 320
  mul y
  add ax, x
  add di, ax
  mov al,couleur
  mov es:[di],al
End;

Function GetPixel(x,y: integer):byte; { Renvoie la couleur d'un pixel }
Var
  _pix: byte;
Begin
  asm
    les di, _buffer        { C'est l'inverse de putpixel. }
    mov ax, 320
    mul y
    add ax, x
    add di, ax
    mov al,es:[di]
    mov _pix,al
  end;
  getpixel:=_pix;
End;

Procedure setcolor(x: byte); { Choix de la couleur de dessin }
Begin
  _couleur:=x;
End;

Procedure SetFps(b: boolean); { Choisit d'affichet le nombre d'images par sec}
Begin
  _BoolFps:=b;
End;
Procedure Line(x1,y1,x2,y2: integer);assembler; { Ligne... }
Var
  xincr, yincr : integer;
Asm
  les di, _buffer   { Algorithme de Bresenham }
  mov ax, 320
  mul y1
  add ax, x1
  add di, ax
  mov dx, 320
  mov bx, y2
  sub bx, y1
  jns @suite1
  neg bx
  neg dx

@suite1:
  mov cx, 1
  mov ax, x2
  sub ax, x1
  jns @suite2
  neg ax
  neg cx

@suite2:
  xor si, si
  mov xincr, cx
  mov yincr, dx
  mov dx, ax
  cmp ax, bx
  jbe @xmineur

  mov cx, ax
  inc cx
  mov al, _couleur

@boucle_xmajeur:
  mov es:[di], al
  add di, xincr
  add si, bx
  cmp si, dx
  jbe @suite3
  sub si, dx
  add di, yincr
@suite3:
  dec cx
  jnz @boucle_xmajeur

  jmp @fin

@xmineur:
  mov cx, bx
  inc cx
  mov al, _couleur
@boucle_xmineur:
  mov es:[di], al
  add di, yincr
  add si, dx
  jle @suite4
  sub si, bx
  add di, xincr
@suite4:
  dec cx
  jnz @boucle_xmineur

@fin:
End;

Procedure Circle(x,y,r: integer);assembler; { Cercle... }
Var
  y1,y2,x1,x2,i,r2: integer;
Asm
  mov cx,x    { Ma version du trac‚ de cercle, me semble plut“t rapide, }
  sub cx,r    { mais je n'ai pas cherch‚ … l'am‚liorer.                 }

@boucle:
  mov ax,cx
  sub ax,x
  mul ax
  mov bx,ax
  mov ax,r
  mul ax
  sub ax,bx    { ax= rý - (i-x)ý }

  mov r2,ax
  mov ax,0
  mov bx,ax
@racine:
  mov ax,bx
  inc ax
  mov bx,ax
  mul ax
  cmp ax,r2
  jl @racine

  mov ax,bx

  mov bx,y
  sub bx,ax
  add ax,y      { ax= y+sqrt(rý- (i-x)ý } { bx= y-sqrt(rý- (i-x)ý }
  push ax

  les di,_buffer
  mov ax,320
  mul bx
  add ax,cx
  add di,ax
  mov al,_couleur
  mov es:[di],al

  pop ax
  mov bx,ax

  les di,_buffer
  mov ax,320
  mul bx
  add ax,cx
  add di,ax
  mov al,_couleur
  mov es:[di],al

  mov ax,x
  add ax,r
  add cx,1
  cmp cx,ax
  jne @boucle



  mov cx,y
  sub cx,r

@boucle2:
  mov ax,cx
  sub ax,y
  mul ax
  mov bx,ax
  mov ax,r
  mul ax
  sub ax,bx    { ax= rý - (i-y)ý }

  mov r2,ax
  mov ax,0
  mov bx,ax
@racine2:
  mov ax,bx
  inc ax
  mov bx,ax
  mul ax
  cmp ax,r2
  jl @racine2

  mov ax,bx

  mov bx,x
  sub bx,ax
  add ax,x      { ax= x+sqrt(rý- (i-y)ý } { bx= y-sqrt(rý- (i-y)ý }

  cmp _style,0
  je @s0
  inc ax
  cmp _style,1
  je @s1

@s0:
  push ax
  les di,_buffer
  mov ax,320
  mul cx
  add ax,bx
  add di,ax
  mov al,_couleur
  mov es:[di],al
  pop ax
  mov bx,ax

  les di,_buffer
  mov ax,320
  mul cx
  add ax,bx
  add di,ax
  mov al,_couleur
  mov es:[di],al
  jmp @fin

@s1:
  push ax
  les di,_buffer
  mov ax,320
  mul cx
  add ax,bx
  add di,ax
  mov al,_couleur
  mov es:[di],al
  pop ax
  inc bx
  cmp bx,ax
  jne @s1
  jmp @fin

@fin:
  mov ax,y
  add ax,r
  add cx,1
  cmp cx,ax
  jne @boucle2
End;

Procedure Rectangle(x1,y1,x2,y2: integer); { Rectangle... }
{Asm
  cmp _style,0
  je @s0
  cmp _style,1
  je @s1

@s1:
  mov bx,y1
  dec bx

@start:
  inc bx
  les di,_buffer
  mov ax,320
  pop dx
  mul bx
  add ax,x1
  mov di,ax
  mov cx,x2
  inc cx
  sub cx,x1
  mov al,_couleur
  rep stosb
  cmp bx,y2
  jne @start
  jmp @fin

@s0:
  les di,_buffer
  mov ax,320
  pop dx
  mul y1
  add ax,x1
  mov di,ax
  mov cx,x2
  inc cx
  sub cx,x1
  mov al,_couleur
  rep stosb

  les di,_buffer
  mov ax,320
  pop dx
  mul y2
  add ax,x1
  mov di,ax
  mov cx,x2
  inc cx
  sub cx,x1
  mov al,_couleur
  rep stosb

  mov bx,y1
  inc bx

@1:
  les di,_buffer
  mov ax,320
  mul bx
  add ax,x1
  add di,ax
  mov al,_couleur
  mov es:[di],al
  inc bx
  cmp bx,y2
  jne @1

  mov bx,y1
  inc bx

@2:
  les di,_buffer
  mov ax,320
  mul bx
  add ax,x2
  add di,ax
  mov al,_couleur
  mov es:[di],al
  inc bx
  cmp bx,y2
  jne @2

  jmp @fin
@fin:
End; } {Ecart‚ … cause de son instabilit‚}
Var
  i: integer;
Begin
  if _style=1 then
    if x2>x1 then for i:=x1 to x2 do line(i,y1,i,y2)
    else for i:=x2 to x1 do line(i,y1,i,y2)
  else
  begin
    line(x1,y1,x2,y1);
    line(x1,y2,x2,y2);
    line(x1,y1,x1,y2);
    line(x2,y1,x2,y2);
  end;
End;

Procedure Triangle(X1,Y1,X2,Y2,X3,Y3:Integer); { Triangle... }
Var
  hx1,hx2:integer;
  bx1,bx2:shortint;
Begin
  if _style=0 then
  begin
    line(x1,y1,x2,y2);    { Tout simplement. }
    line(x1,y1,x3,y3);
    line(x2,y2,x3,y3);
  end;
  if _style=1 then
  asm
    Mov Ax,Y2
    Cmp Y1,Ax
    Jl @Sup1
    Xchg Y1,Ax
    Mov Y2,Ax
    Mov Ax,X1
    Xchg X2,Ax
    Mov X1,Ax

  @Sup1:
    Mov Ax,Y3
    Cmp Y1,Ax
    Jl @Sup2
    Xchg Y1,Ax
    Mov Y3,Ax
    Mov Ax,X1
    Xchg X3,Ax
    Mov X1,Ax

  @Sup2:
    Mov Ax,Y3
    Cmp Y2,Ax
    Jl @Sup3
    Xchg Y2,Ax
    Mov Y3,Ax
    Mov Ax,X2
    Xchg X3,Ax
    Mov X2,Ax

  @Sup3:
    Mov Bx,Y3
    Sub Bx,Y1
    Jz @Finie

    les di,_buffer
    mov ax,320
    Mov Ax,Y1
    Shl Ax,6
    Mov Di,Ax
    Shl Ax,2
    Add Di,Ax
    Add Di,X1

    Xor Dx,Dx
    Mov Hx2,Dx
    Mov Ax,X3
    Sub Ax,X1
    Jnc @PasInfe
    Dec Dx

  @PasInfe:
    Shl Ax,8
    Idiv Bx
    Mov Byte Ptr Hx2,Ah
    Mov Bx2,Al

    Cmp Ax,0
    Jge @azer
    Sub Hx2,256

  @azer:
    Add Hx2,320

    Mov Cx,Y2
    Sub Cx,Y1
    Jnz @Y2_Y1_Different
    Mov Si,Di
    Sub Di,X1
    Add Di,X2
    Mov Bx,Di
    Jmp @MoitieFinie
    @Y2_Y1_Different:
    inc Cx

    Mov Bx,Cx

    Xor Dx,Dx
    Mov Hx1,Dx
    Mov Ax,X2
    Sub Ax,X1
    Jnc @PasInfe3
    Dec Dx

  @PasInfe3:
    Shl Ax,8
    Idiv Bx

    Mov Bx1,Al
    Mov Byte ptr Hx1,Ah

    Cmp Ax,0
    Jge @okl
    Sub Hx1,256

  @okl:
    Add Hx1,320

    Mov Bx,Di
    Mov Si,Di

    Mov Dh,bx2
    mov Dl,bx1

  @Boucle:
    Push Cx
    Push Ax

    Mov Di,Bx
    Mov Cx,Si
    Sub Cx,Bx
    Jnc @okj
    Neg Cx
    Mov Di,Si

  @okj:
    Inc cx

    Mov ah,_couleur
    Mov Al,Ah

    Rep Stosb

    Pop Ax

    Add al,Dl
    Adc Bx,Hx1

    Add ah,Dh
    Adc Si,Hx2

    Pop Cx

    Dec Cx
    Jg @Boucle

  @MoitieFinie:
    Mov Cx,Y3
    Sub Cx,Y2
    Jz @Finie
    Inc Y3

    Mov Cx,Bx

    Xor Dx,Dx
    Mov Hx1,Dx
    Mov Ax,X3
    Sub Ax,X2
   jnc @PasInfe5
    Dec Dx

  @PasInfe5:
    Shl Ax,8
    Mov Bx,Y3
    Sub Bx,Y2
    Idiv Bx

    Mov byte ptr Hx1,Ah
    Mov Bx1,Al
    Cmp Ax,0
    jge @okl1
    Sub Hx1,256

  @okl1:
    Add Hx1,320

    Mov Bx,Cx

    Mov Cx,Y3
    Sub Cx,Y2

    Mov dl,bx1
    Mov dh,bx2

  @Boucle2:
    Push cx
    Push Ax

    Mov Di,Bx
    Mov Cx,Si
    Sub Cx,Bx

    Jnc @okj1
    Neg Cx
    Mov Di,Si

  @okj1:
    Mov Ah,_couleur
    Mov Al,Ah

    Rep Stosb

    Pop ax

    Add al,dl
    Adc Bx,Hx1

    Add ah,dh
    Adc Si,Hx2

    Pop cx

    Dec Cx
    Jg @Boucle2

  @Finie:
  end;
End;

Procedure Ech(var a,b: integer);  { Permutation de deux entiers. }
Var                               { Procedure … usage interne.   }
  t: integer;
Begin
  t:=a;
  a:=b;
  b:=t;
End;

Procedure Quadri(x1,y1,x2,y2,x3,y3,x4,y4: integer); { QuadrilatŠre... }
Begin
  if x1>x2 then     { Je ne suis pas s–r que cel… marche toujours... }
  begin
    ech(x1,x2);
    ech(y1,y2);
  end;
  if x1>x3 then
  begin
    ech(x1,x3);
    ech(y1,y3);
  end;
  if x1>x4 then
  begin
    ech(x1,x4);
    ech(y1,y4);
  end;
  if x2>x3 then
  begin
    ech(x2,x3);
    ech(y2,y3);
  end;
  if x4<x3 then
  begin
    ech(x4,x3);
    ech(y4,y3);
  end;

  if _style=0 then
  begin
    line(x1,y1,x2,y2);
    line(x2,y2,x3,y3);
    line(x3,y3,x4,y4);
    line(x4,y4,x1,y1);
  end;
  if _style=1 then
  begin
    triangle(x1,y1,x2,y2,x3,y3);
    triangle(x2,y2,x3,y3,x4,y4);
  end;
End;

Procedure SetStyle(x: byte);  {Style:  0 Contour   1 Rempli }
Begin
  _style:=x;   { Variable globale de style }
End;

Procedure SetRGBPalette(Num, R, G, B: Byte); { Change une couleur }
Begin
  Asm
    mov dx,3c8h        { Change une couleur de la palette selon ses composants }
    mov al,[num]       { RGB et son emplacement dans la palette.               }
    out dx,al
    inc dx
    mov al,[r]
    out dx,al
    mov al,[g]
    out dx,al
    mov al,[b]
    out dx,al
  End;
  _currentpalette[num*3]:=r;
  _currentpalette[num*3+1]:=g;
  _currentpalette[num*3+2]:=b;

End;

Function Get(x,y: integer; truc: sprite):byte;
Var
  _pix: byte;
Begin                 { Fonction … usage interne. Permet en fait de faire }
  asm                 { un getpixel dans un Sprite.                       }
    les di, truc
    mov ax, 320
    mul y
    add ax, x
    add di, ax
    mov al,es:[di]
    mov _pix,al
  end;
  get:=_pix;
End;

Procedure Put(x,y: integer ; couleur: byte; truc: sprite); assembler;
Asm
  les di, truc       { Fonction … usage interne. Permet en fait de faire }
  mov ax, 320        { un putpixel dans un Sprite.                       }
  mul y
  add ax, x
  add di, ax
  mov al,couleur
  mov es:[di],al
End;


Procedure OutChar(x,y: integer; coul: byte; car: char);
Var
  i, j, k, l: integer;
Begin
  if (car='A') or (car='a') or (car='1') then k:=1;
  if (car='B') or (car='b') or (car='2') then k:=2;
  if (car='C') or (car='c') or (car='3') then k:=3;
  if (car='D') or (car='d') or (car='4') then k:=4;
  if (car='E') or (car='e') or (car='5') then k:=5;
  if (car='F') or (car='f') or (car='6') then k:=6;
  if (car='G') or (car='g') or (car='7') then k:=7;
  if (car='H') or (car='h') or (car='8') then k:=8;
  if (car='I') or (car='i') or (car='9') then k:=9;
  if (car='J') or (car='j') or (car='0') then k:=10;
  if (car='K') or (car='k') then k:=11;
  if (car='L') or (car='l') then k:=12;
  if (car='M') or (car='m') then k:=13;
  if (car='N') or (car='n') then k:=14;
  if (car='O') or (car='o') then k:=15;
  if (car='P') or (car='p') then k:=16;
  if (car='Q') or (car='q') then k:=17;
  if (car='R') or (car='r') then k:=18;
  if (car='S') or (car='s') then k:=19;
  if (car='T') or (car='t') then k:=20;
  if (car='U') or (car='u') then k:=21;
  if (car='V') or (car='v') then k:=22;
  if (car='W') or (car='w') then k:=23;
  if (car='X') or (car='x') then k:=24;
  if (car='Y') or (car='y') then k:=25;
  if (car='Z') or (car='z') then k:=26;
  if (car>='A') and (car<='Z') then l:=1;
  if (car>='a') and (car<='z') then l:=2;
  if (car>='0') and (car<='9') then l:=3;

  for i:=1 to 5 do for j:=1 to 10 do
  if get(k*6+i-6,l*11+j-11,_fontspr)=1 then
    putpixel(x+i-1,y+j-1,coul);
End;

Procedure OutText(x,y: integer; texte: string);
Var
  i: integer;
Begin
  for i:=1 to length(texte) do if texte[i]<>' ' then
    outchar(x+i*6-6,y-2,_couleur,texte[i]);
End;


Procedure SaveSprite(fto: string; x1,y1,x2,y2: integer);
Var
  f: text;           { Utilisez … vos risques et p‚rils ! Moi j'y arrive,    }
  i, j: integer;     { c'est peut ˆtre moins ‚vident pour quelqu'un d'autre. }
Begin
  If (x1>x2) or (y1>y2) then
  begin
    ech(x1,x2);
    ech(y1,y2);
  end;
  Assign(f,fto);
  Rewrite(f);
  For j:=y1 to y2 do for i:=x1 to x2 do write(f,chr(getpixel(i,j)));
  Close(f);
End;

Procedure AffSprite(var spr: sprite; x1,y1,x2,y2: integer);
Var
  i,j: integer;    { Toujours pareil: utilisation pas ‚vidente. }
Begin
  i:=0;
  j:=0;
  Repeat
  Begin
    putpixel(i+x1,j+y1,get(i,j,spr));
    inc(i);
    if i=x2+1-x1 then
    begin
      i:=0;
      inc(j);
    end;
  End;
  Until j=y2+1-y1;
End;

Procedure LoadSprite(fto: string; x1,y1,x2,y2: integer; var spr: sprite);
Var
  f: text;
  i, j: integer;   { Toujours pareil: utilisation pas ‚vidente. }
  truc: char;
Begin
  GetMem(spr,64000);
  Assign(f,fto);
  Reset(f);
  i:=0;
  j:=0;
  Repeat
  Begin
    read(f,truc);
    put(i,j,ord(truc),spr);
    inc(i);
    if i=x2+1 then
    begin
      i:=0;
      inc(j);
    end;
  End;
  Until j=y2+1;
  Close(f);
End;

Procedure CloseSprite(var spr: sprite);
Begin
  dispose(spr);   { Indispensable: lib‚ration de la m‚moire occup‚e par le }
End;              { Sprite. Si ce n'est pas fait, gare au plantage !       }

Procedure ChargePCX(nomfichier : string; var destination: Pbyte; var Palette : Palette);
var
  f: file of byte;   { Charge uniquement des PCX en 320*200*256 }
  octet : byte;      { Voir les exemples pour l'utilisation.    }
  count : longint;
  repetition : byte;
  ptr : PByte;
  i : integer;
begin
  Getmem(destination, 64000);
  assign(f, nomfichier);
  reset(f);

  seek(f, 128);

  ptr := destination;
  count:=0;
  while(count<320*200) do
  begin
    read(f,octet);
    if(octet>$C0) then
    begin
      repetition:=octet-$C0;
      read(f,octet);
      for i:=1 to repetition do
      begin
        ptr^:=octet;
        inc(ptr);
        inc(count);
      end;
    end else
    begin
      ptr^:=octet;
      inc(ptr);
      inc(count);
    end;
  end;
  read(f,octet);
  for i:=0 to 767 do
  begin
    read(f,octet);
    Palette[i]:=(octet SHR 2);
  end;
  close(f);
end;

Procedure PcxToSpr(ifile,ofile: string); { Convertisseur PCX -> SPR }
Var
  pal: palette;        { Attention, les couleurs changent ! }
  i,j,dif: integer;    { Le SPR risque de diff‚rer du PCX ! }
  col: array [0..255] of byte;
  ofi: text;
Begin
  ChargePCX(ifile,_buffer,pal);
  for i:=0 to 255 do setrgbpalette(i,pal[i*3],pal[i*3-2],pal[i*3-1]);
  for j:=0 to 255 do
  begin
    dif:=10000;
    for i:=16 to 255 do if abs(pal[j*3]-_palette[i*3])+abs(pal[j*3-2]-_palette[i*3-2])+
    abs(pal[j*3-1]-_palette[i*3-1])<=dif then
    begin
      dif:=abs(pal[i*3]-_palette[i*3])+abs(pal[i*3-2]-_palette[i*3-2])+abs(pal[i*3-1]-_palette[i*3-1]);
      col[j]:=i;
    end;
  end;

  assign(ofi,ofile);
  rewrite(ofi);
  for i:=0 to 199 do for j:=0 to 319 do write(ofi,chr(col[getpixel(j,i)]));
  close(ofi);
  i:=0;
  repeat
  begin
    setrgbpalette(i div 3,_palette[i],_palette[i+1],_palette[i+2]);
    i:=i+3;
  end;
  until i>767;
End;

Function IntToStr(I: longint): String;
Var
  S: string[11];
Begin
  Str(I, S);
  IntToStr := S;
End;

End.