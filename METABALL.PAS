Program MetaBallz; { Kouiskas, fast compo sur #codefr }

{ J'ai mis le source, paske je le vaux bien ;) }

{ J'ai pas comment‚ le prog, c'est trop chiant. Donc vous aurez peut-ˆtre
  du mal … tout comprendre... D‚sol‚ mais j'ai pas que ‡… … faire. }

Uses crt, graph256, dos;

Const
  nbmetamax=1000;  { Nombre maximum de metaballs }
  depcouleur=1;   { Couleur de d‚part du cycle }
  taille=16;      { Taille des metaballs }
  maxspeed=2;     { Ne sert plus … grand chose... }
  hazard=15;

Type
  Meta= record
          x, y, vx, vy, r, attir: integer;
        end;
  spe= array [1..13] of record
                          lettre: char;
                          numattir: byte;
                          x, y: integer;
                          point: array [1..3] of integer;
                        end;
Var
  fic: file of spe;
  texture, fond: sprite;
  metaball: array [0..nbmetamax] of meta;
  i, j: integer;
  attir: spe;
  lettre: integer;
  quit: boolean;
  desti: integer;
  heure, minute, seconde, cent, count: word;
  couleur, nbmeta: integer;

Procedure ClearSpr(couleur: byte; spr: sprite); assembler;
Asm
  les di, spr
  mov cx, 16000
  db $66, $33, $DB        { xor ebx,ebx }
  mov bl, couleur
  mov bh, bl
  mov ax, bx
  db $66, $C1, $E0, $10   { shl eax, 16 }
  db $66, $03, $C3        { add eax, ebx }
  db $F3, $66, $AB        { rep stosd }
End;

Procedure fadein(pal: palette);
Var
  pal2: palette;
  bool: boolean;
Begin
  for i:=0 to 767 do pal2[i]:=0;
  repeat
    for i:=0 to 255 do setrgbpalette(i,pal2[i*3],pal2[i*3+1],pal2[i*3+2]);
    refresh;
    bool:=false;
    for i:=0 to 767 do
    begin
      if pal2[i]<pal[i] then
      begin
        inc(pal2[i]);
        bool:=true;
      end;
    end;
  until not bool;
End;

Procedure fadeout(pal: palette);
Var
  bool: boolean;
  i: integer;
Begin
  repeat
    for i:=0 to 255 do setrgbpalette(i,pal[i*3],pal[i*3+1],pal[i*3+2]);
    refresh;
    bool:=false;
    for i:=0 to 767 do if pal[i]>0 then
    begin
      dec(pal[i]);
      bool:=true;
    end;
  until not bool;
End;

Procedure metathink; forward;

Procedure palettenew(trans: boolean);
Var
  x: integer;
  pal2, pal3: palette;
  bool: boolean;
Begin
  if couleur=1 then for x:=1 to 32 do
  begin
    pal2[x*3]:=x*2-1; pal2[x*3+1]:=0; pal2[x*3+2]:=0;
    pal2[(x+32)*3]:=63; pal2[(x+32)*3+1]:=x*2-1; pal2[(x+32)*3+2]:=0;
  end else
  if couleur=2 then for x:=1 to 32 do
  begin
    pal2[x*3]:=0; pal2[x*3+1]:=0; pal2[x*3+2]:=x*2-1;
    pal2[(x+32)*3]:=0; pal2[(x+32)*3+1]:=x*2-1; pal2[(x+32)*3+2]:=63;
  end else
  if couleur=3 then for x:=1 to 32 do
  begin
    pal2[x*3]:=0; pal2[x*3+1]:=x*2-1; pal2[x*3+2]:=0;
    pal2[(x+32)*3]:=0; pal2[(x+32)*3+1]:=63; pal2[(x+32)*3+2]:=x*2-1;
  end else
  if couleur=4 then for x:=1 to 32 do
  begin
    pal2[x*3]:=x*2-1; pal2[x*3+1]:=x*2-1; pal2[x*3+2]:=0;
    pal2[(x+32)*3]:=63; pal2[(x+32)*3+1]:=63; pal2[(x+32)*3+2]:=x*2-1;
  end else
  if couleur=5 then for x:=1 to 32 do
  begin
    pal2[x*3]:=0; pal2[x*3+1]:=x*2-1; pal2[x*3+2]:=x*2-1;
    pal2[(x+32)*3]:=x*2-1; pal2[(x+32)*3+1]:=63; pal2[(x+32)*3+2]:=63;
  end;
  if not trans then
    for i:=1 to 64 do setrgbpalette(i,pal2[i*3],pal2[i*3+1],pal2[i*3+2])
  else
  begin
    pal3:=_currentpalette;
    repeat
      clear(0);
      metathink;
      bool:=false;
      for i:=1 to 64 do setrgbpalette(i,pal3[i*3],pal3[i*3+1],pal3[i*3+2]);
      refresh;
      for i:=1 to 64*3 do if pal3[i]<pal2[i] then
      begin
        bool:=true;
        inc(pal3[i]);
      end
      else if pal3[i]>pal2[i] then
      begin
        bool:=true;
        dec(pal3[i]);
      end;
    until not (bool) or (quit);
    clear(0);
    metathink;
    palettenew(false);
    refresh;
  end;
End;

Procedure Put2(x,y: integer ; couleur: byte; truc: sprite); assembler;
Asm
  les di, truc
  mov ax, taille
  mov bx,2
  mul bx
  mul y
  add ax, x
  add di, ax
  mov al,couleur
  mov es:[di],al
End;

Procedure drawmeta(m: meta);
Var
  dest: integer;
  i, i2, j, j2, mx2, my2: integer;
Begin
  for i:=m.x-m.r to m.x+m.r do for j:=m.y-m.r to m.y+m.r do
  begin
    mx2:=m.x;
    my2:=m.y;
    asm
      mov ax, i
      sub ax, mx2
      add ax, taille
      mov i2, ax
      mov ax, j
      sub ax, my2
      add ax, taille
      mov j2, ax

      les di, texture
      mov ax, taille
      mov bx, 2
      mul bx
      mul j2
      add ax, i2
      add di, ax
      mov al, es:[di]
      push ax

      les di, _buffer
      mov ax, 320
      mul j
      add ax, i
      add di, ax
      mov al, es:[di]
      pop bx
      add bl, al
      cmp bl, 63
      jle @truc
      mov bl,63
    @truc:
      mov es:[di],bl
    end;
  end;
End;

Procedure lettreseek(let: char);
Var
  attir2: spe;
Begin
  reset(fic);
  repeat read(fic,attir2) until (attir2[1].lettre=let) or (eof(fic));
  attir:=attir2;
End;

Procedure InitMeta;
Var
  x, y: integer;
  d, c: real;
Begin
  count:=0;
  randomize;
  init256;
  clear(0);
  refresh;
  delay(1000);
  assign(fic,'lettres.met');
  reset(fic);

  couleur:=2;
  palettenew(false);
  loadsprite('13h.spr',0,0,319,199,fond);
  affsprite(fond,0,0,319,199);
  fadein(_currentpalette);
  delay(2000);
  fadeout(_currentpalette);
  clear(0);
  refresh;
  closesprite(fond);
  couleur:=3;
  palettenew(false);
  clear(0);
  refresh;
  delay(1000);
  loadsprite('2d.spr',0,0,319,199,fond);
  affsprite(fond,0,0,319,199);
  fadein(_currentpalette);
  delay(2000);
  fadeout(_currentpalette);
  clear(0);
  refresh;
  closesprite(fond);
  delay(1000);
  if (paramcount=1) and (paramstr(1)='-fps') then setfps(true);
  loadsprite('2d.spr',0,0,319,199,fond);

  couleur:=depcouleur;
  palettenew(false);
  lettre:=0;
  quit:=false;
  for i:=1 to 10 do
  begin
    attir[i].x:=0;
    attir[i].y:=0;
  end;

  getmem(texture,taille*4*taille);
  clearspr(0,texture);
  for x:=-taille to taille do for y:=-taille to taille do
  begin
    d:=x*x + y*y;
    if sqrt(abs(d))<=taille then
    begin
      c:=(30*cos(sqrt(abs(d))*pi/taille)+30);
      if c>64 then c:=64;
      put2(x+taille,y+taille,round(c),texture);
    end else put2(x+taille,y+taille,0,texture);
  end;

  for x:=0 to nbmeta do
  begin
    metaball[x].x:=random(310-taille*2)+taille+5;
    metaball[x].y:=random(190-taille*2)+taille+5;
    metaball[x].vx:=random(maxspeed)+5;
    metaball[x].vy:=random(maxspeed)+5;
    metaball[x].r:=taille;
    metaball[x].attir:=0;
  end;
  attir[1].numattir:=0;
  desti:=4;
  gettime(heure,minute,count,cent);
End;

Procedure MetaThink;
Var
  i, j, dif, c2: integer;
Begin
  gettime(heure,minute,seconde,cent);
  dif:=count+desti;
  if dif>59 then dif:=dif-60;
  if (keypressed) and (readkey=#27) then quit:=true;
  if seconde=dif then
  begin
    gettime(heure,minute,seconde,cent);
    count:=seconde;
    desti:=2;
    inc(lettre);
    if lettre=9 then lettre:=0;
    case lettre of
      1: lettreseek('k');
      2: lettreseek('o');
      3: lettreseek('u');
      4: lettreseek('i');
      5: lettreseek('s');
      6: lettreseek('k');
      7: lettreseek('a');
      8: lettreseek('s');
    end;
    if lettre=0 then
    begin
      desti:=4;
      attir[1].numattir:=0;
      for i:=0 to nbmeta do
        metaball[i].attir:=0;
      repeat c2:=random(5)+1 until c2<>couleur;
      couleur:=c2;
      palettenew(true);
      clear(0);
    end else for i:=0 to nbmeta do
     metaball[i].attir:=random(attir[1].numattir)+1;
  end;
  for i:=0 to nbmeta do
  begin
    if metaball[i].x+metaball[i].r>=315 then
    begin
      metaball[i].x:=metaball[i].x-metaball[i].vx-2;
      metaball[i].vx:=-metaball[i].vx;
    end else
    if metaball[i].x-metaball[i].r<=5 then
    begin
      metaball[i].x:=metaball[i].x-metaball[i].vx+2;
      metaball[i].vx:=-metaball[i].vx;
    end;
    if metaball[i].y+metaball[i].r>=195 then
    begin
      metaball[i].y:=metaball[i].y-metaball[i].vy-2;
      metaball[i].vy:=-metaball[i].vy;
    end else
    if metaball[i].y-metaball[i].r<=5 then
    begin
      metaball[i].y:=metaball[i].y-metaball[i].vy+2;
      metaball[i].vy:=-metaball[i].vy;
    end;

    for j:=1 to attir[1].numattir do if (metaball[i].attir=j) then
    begin
      if metaball[i].x>attir[j].x then
        metaball[i].x:=metaball[i].x-((metaball[i].x-attir[j].x) div (random(10)+2))
     else
        metaball[i].x:=metaball[i].x+((attir[j].x-metaball[i].x) div (random(10)+2));

      if metaball[i].y>attir[j].y then
        metaball[i].y:=metaball[i].y-((metaball[i].y-attir[j].y) div (random(10)+2))
      else
        metaball[i].y:=metaball[i].y+((attir[j].y-metaball[i].y) div (random(10)+2));
    end;

    metaball[i].x:=metaball[i].x+metaball[i].vx;
    metaball[i].y:=metaball[i].y+metaball[i].vy;

    if random(hazard)=0 then inc(metaball[i].vx);
    if random(hazard)=0 then inc(metaball[i].vy);
    if random(hazard)=1 then dec(metaball[i].vx);
    if random(hazard)=1 then dec(metaball[i].vy);
    if random(15)=1 then metaball[i].attir:=attir[metaball[i].attir].point[random(3)+1];
    if lettre=0 then
    begin
      if metaball[i].vx>=maxspeed+1 then metaball[i].vx:=maxspeed;
      if metaball[i].vy>=maxspeed+1 then metaball[i].vy:=maxspeed;
      if metaball[i].vx<=-maxspeed-1 then metaball[i].vx:=-maxspeed;
      if metaball[i].vy<=-maxspeed-1 then metaball[i].vy:=-maxspeed;
    end else
    begin
      if metaball[i].vx>=maxspeed+1 then metaball[i].vx:=maxspeed;
      if metaball[i].vy>=maxspeed+1 then metaball[i].vy:=maxspeed;
      if metaball[i].vx<=-maxspeed-1 then metaball[i].vx:=-maxspeed;
      if metaball[i].vy<=-maxspeed-1 then metaball[i].vy:=-maxspeed;
    end;
    drawmeta(metaball[i]);
  end;
End;

Procedure choix;
Var
  str: string;
  temp: integer;
Begin
  clrscr;
  writeln('**************************** Kouskous OS loaded ;) *****************************');
  write('Veuillez entrer le nombre de metaballz voulues (d‚faut=100): ');
  readln(str);
  if str<>'' then val(str,nbmeta,temp) else nbmeta:=100;
  if (temp>0) and (str<>'') then choix;
  if nbmeta>nbmetamax then nbmeta:=nbmetamax;
  dec(nbmeta);
End;

Begin
  choix;
  initmeta;
  repeat
    clear(0);
    metathink;
    setcolor(63);
    refresh;
  until quit=true;
  freemem(fond,64000);
  freemem(texture,taille*4*taille);
  close(fic);
  close256;
End.