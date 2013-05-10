Program metalettre; { Kouiskas! }

{ Programme g‚n‚rant le fichier lettres.met, qui contient les coordonn‚es
  des points d'attraction des diff‚rentes lettres }

Uses dos, crt;

Type
  spe= array [1..13] of record
                          lettre: char;
                          numattir: byte;
                          x, y: integer;
                          point: array [1..3] of integer;
                        end;

Var
  fic: file of spe;
  attir: spe;
  nbattir, lettre: integer;

Procedure ecrire;
Var
  i: integer;
Begin
  write(fic,attir);
End;

Begin
  assign(fic,'lettres.met');
  rewrite(fic);
  attir[1].x:=100;  attir[1].y:=20;
  attir[2].x:=100;  attir[2].y:=180;
  attir[3].x:=100;  attir[3].y:=100;
  attir[4].x:=200;  attir[4].y:=30;
  attir[5].x:=200;  attir[5].y:=180;
  attir[6].x:=150;  attir[6].y:=100;

  attir[1].point[1]:=3;
  attir[2].point[1]:=3;
  attir[3].point[1]:=1;
  attir[4].point[1]:=6;
  attir[5].point[1]:=6;
  attir[6].point[1]:=3;

  attir[1].point[2]:=3;
  attir[2].point[2]:=3;
  attir[3].point[2]:=2;
  attir[4].point[2]:=6;
  attir[5].point[2]:=6;
  attir[6].point[2]:=4;

  attir[1].point[3]:=3;
  attir[2].point[3]:=3;
  attir[3].point[3]:=6;
  attir[4].point[3]:=6;
  attir[5].point[3]:=6;
  attir[6].point[3]:=5;
  attir[1].numattir:=6;
  attir[1].lettre:='k';
  ecrire;
  attir[1].x:=160;  attir[1].y:=20;
  attir[2].x:=210;  attir[2].y:=40;
  attir[3].x:=220;  attir[3].y:=60;
  attir[4].x:=235;  attir[4].y:=100;
  attir[5].x:=220;  attir[5].y:=140;
  attir[6].x:=210;  attir[6].y:=160;
  attir[7].x:=160;  attir[7].y:=180;
  attir[8].x:=110;  attir[8].y:=160;
  attir[9].x:=100;  attir[9].y:=140;
  attir[10].x:=85; attir[10].y:=100;
  attir[11].x:=100; attir[11].y:=60;
  attir[12].x:=110; attir[12].y:=40;

  attir[1].point[1]:=12;
  attir[2].point[1]:=1;
  attir[3].point[1]:=2;
  attir[4].point[1]:=3;
  attir[5].point[1]:=4;
  attir[6].point[1]:=5;
  attir[7].point[1]:=6;
  attir[8].point[1]:=7;
  attir[9].point[1]:=8;
  attir[10].point[1]:=9;
  attir[11].point[1]:=10;
  attir[12].point[1]:=11;

  attir[1].point[2]:=2;
  attir[2].point[2]:=3;
  attir[3].point[2]:=4;
  attir[4].point[2]:=5;
  attir[5].point[2]:=6;
  attir[6].point[2]:=7;
  attir[7].point[2]:=8;
  attir[8].point[2]:=9;
  attir[9].point[2]:=10;
  attir[10].point[2]:=11;
  attir[11].point[2]:=12;
  attir[12].point[2]:=1;

  attir[1].point[3]:=2;
  attir[2].point[3]:=3;
  attir[3].point[3]:=4;
  attir[4].point[3]:=5;
  attir[5].point[3]:=6;
  attir[6].point[3]:=7;
  attir[7].point[3]:=8;
  attir[8].point[3]:=9;
  attir[9].point[3]:=10;
  attir[10].point[3]:=11;
  attir[11].point[3]:=12;
  attir[12].point[3]:=1;
  attir[1].numattir:=12;
  attir[1].lettre:='o';
  ecrire;
  attir[1].x:=220;  attir[1].y:=40;
  attir[2].x:=235;  attir[2].y:=100;
  attir[3].x:=220;  attir[3].y:=140;
  attir[4].x:=210;  attir[4].y:=160;
  attir[5].x:=160;  attir[5].y:=180;
  attir[6].x:=110;  attir[6].y:=160;
  attir[7].x:=100;  attir[7].y:=140;
  attir[8].x:=85; attir[8].y:=100;
  attir[9].x:=100; attir[9].y:=40;

  attir[1].point[1]:=2;
  attir[2].point[1]:=3;
  attir[3].point[1]:=4;
  attir[4].point[1]:=5;
  attir[5].point[1]:=6;
  attir[6].point[1]:=7;
  attir[7].point[1]:=8;
  attir[8].point[1]:=9;
  attir[9].point[1]:=9;

  attir[1].point[2]:=2;
  attir[2].point[2]:=1;
  attir[3].point[2]:=4;
  attir[4].point[2]:=3;
  attir[5].point[2]:=6;
  attir[6].point[2]:=5;
  attir[7].point[2]:=8;
  attir[8].point[2]:=7;
  attir[9].point[2]:=8;

  attir[1].point[3]:=2;
  attir[2].point[3]:=1;
  attir[3].point[3]:=2;
  attir[4].point[3]:=3;
  attir[5].point[3]:=4;
  attir[6].point[3]:=5;
  attir[7].point[3]:=6;
  attir[8].point[3]:=7;
  attir[9].point[3]:=9;
  attir[1].numattir:=9;
  attir[1].lettre:='u';
  ecrire;
  attir[1].x:=130;  attir[1].y:=20;
  attir[2].x:=160;  attir[2].y:=20;
  attir[3].x:=190;  attir[3].y:=20;
  attir[4].x:=160;  attir[4].y:=70;
  attir[5].x:=160;  attir[5].y:=100;
  attir[6].x:=160;  attir[6].y:=130;
  attir[7].x:=130;  attir[7].y:=180;
  attir[8].x:=160; attir[8].y:=180;
  attir[9].x:=190; attir[9].y:=180;

  attir[1].point[1]:=2;
  attir[2].point[1]:=3;
  attir[3].point[1]:=2;
  attir[4].point[1]:=2;
  attir[5].point[1]:=6;
  attir[6].point[1]:=8;
  attir[7].point[1]:=8;
  attir[8].point[1]:=9;
  attir[9].point[1]:=9;

  attir[1].point[2]:=2;
  attir[2].point[2]:=1;
  attir[3].point[2]:=2;
  attir[4].point[2]:=5;
  attir[5].point[2]:=6;
  attir[6].point[2]:=8;
  attir[7].point[2]:=8;
  attir[8].point[2]:=7;
  attir[9].point[2]:=8;

  attir[1].point[3]:=1;
  attir[2].point[3]:=4;
  attir[3].point[3]:=3;
  attir[4].point[3]:=2;
  attir[5].point[3]:=4;
  attir[6].point[3]:=5;
  attir[7].point[3]:=7;
  attir[8].point[3]:=6;
  attir[9].point[3]:=9;
  attir[1].numattir:=9;
  attir[1].lettre:='i';
  ecrire;
  attir[1].x:=220;  attir[1].y:=40;
  attir[2].x:=200;  attir[2].y:=20;
  attir[3].x:=160;  attir[3].y:=20;
  attir[4].x:=120;  attir[4].y:=20;
  attir[5].x:=100;  attir[5].y:=50;
  attir[6].x:=120;  attir[6].y:=80;
  attir[7].x:=160;  attir[7].y:=90;  {220 160 }
  attir[8].x:=200; attir[8].y:=100;
  attir[9].x:=220; attir[9].y:=140;
  attir[10].x:=200; attir[10].y:=180;
  attir[11].x:=160; attir[11].y:=180;
  attir[12].x:=120; attir[12].y:=180;
  attir[13].x:=100; attir[13].y:=160;

  attir[1].point[1]:=2;
  attir[2].point[1]:=3;
  attir[3].point[1]:=4;
  attir[4].point[1]:=5;
  attir[5].point[1]:=6;
  attir[6].point[1]:=7;
  attir[7].point[1]:=8;
  attir[8].point[1]:=9;
  attir[9].point[1]:=10;
  attir[10].point[1]:=11;
  attir[11].point[1]:=12;
  attir[12].point[1]:=13;
  attir[13].point[1]:=13;

  attir[1].point[2]:=2;
  attir[2].point[2]:=1;
  attir[3].point[2]:=4;
  attir[4].point[2]:=3;
  attir[5].point[2]:=6;
  attir[6].point[2]:=5;
  attir[7].point[2]:=8;
  attir[8].point[2]:=7;
  attir[9].point[2]:=8;
  attir[10].point[2]:=9;
  attir[11].point[2]:=10;
  attir[12].point[2]:=11;
  attir[13].point[2]:=12;

  attir[1].point[3]:=2;
  attir[2].point[3]:=1;
  attir[3].point[3]:=2;
  attir[4].point[3]:=3;
  attir[5].point[3]:=4;
  attir[6].point[3]:=5;
  attir[7].point[3]:=6;
  attir[8].point[3]:=7;
  attir[9].point[3]:=9;
  attir[10].point[3]:=10;
  attir[11].point[3]:=11;
  attir[12].point[3]:=12;
  attir[13].point[3]:=13;
  attir[1].numattir:=13;
  attir[1].lettre:='s';
  ecrire;
  attir[1].x:=100;  attir[1].y:=180;
  attir[2].x:=100;  attir[2].y:=140;
  attir[3].x:=100;  attir[3].y:=100;
  attir[4].x:=110;  attir[4].y:=40;
  attir[5].x:=160;  attir[5].y:=30;
  attir[6].x:=210;  attir[6].y:=40;
  attir[7].x:=220;  attir[7].y:=100;
  attir[8].x:=140;  attir[8].y:=100;
  attir[9].x:=180; attir[9].y:=100;
  attir[10].x:=220; attir[10].y:=140;
  attir[11].x:=220; attir[11].y:=180;

  attir[1].point[1]:=1;
  attir[2].point[1]:=2;
  attir[3].point[1]:=2;
  attir[4].point[1]:=5;
  attir[5].point[1]:=6;
  attir[6].point[1]:=7;
  attir[7].point[1]:=6;
  attir[8].point[1]:=9;
  attir[9].point[1]:=8;
  attir[10].point[1]:=10;
  attir[11].point[1]:=11;

  attir[1].point[2]:=1;
  attir[2].point[2]:=1;
  attir[3].point[2]:=4;
  attir[4].point[2]:=5;
  attir[5].point[2]:=4;
  attir[6].point[2]:=7;
  attir[7].point[2]:=8;
  attir[8].point[2]:=9;
  attir[9].point[2]:=3;
  attir[10].point[2]:=7;
  attir[11].point[2]:=10;

  attir[1].point[3]:=2;
  attir[2].point[3]:=3;
  attir[3].point[3]:=9;
  attir[4].point[3]:=3;
  attir[5].point[3]:=4;
  attir[6].point[3]:=5;
  attir[7].point[3]:=10;
  attir[8].point[3]:=7;
  attir[9].point[3]:=3;
  attir[10].point[3]:=11;
  attir[11].point[3]:=11;
  attir[1].numattir:=11;
  attir[1].lettre:='a';
  ecrire;
  readln;
  close(fic);
End.