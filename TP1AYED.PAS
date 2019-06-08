program ReservaEstudiantil;
{$N+}
uses
    CRT;

type
    Institucion = record
           CodPedido : byte;
           Nombre : string[30];
           CantAlum : byte;
           CodDest : byte;
           Fecha : longint
    End;
type
    Alumno = record
           CodPedido : byte;
           Dni : longint;
           ApNom : string [30];
           Edad : byte
    End;

ArchInst = file of Institucion;
ArchAlum = file of Alumno;

function Temporada ( fecha : longint ) : boolean;
    var
       mes: byte;

    begin
       mes:= (fecha div 100)mod 100;

       if ((mes=09) or (mes=10)) then
          Temporada:=true
       else
          Temporada:=false
    end;

function Descuento (cant: byte; importe:single): single;
    var
       alum : byte;
       desc : single;
    begin
       alum:=cant;
       if (alum>90) then
          desc:=((importe * 5)/100)
       else
           desc:=0;
       Descuento:=desc
    end;
function asientos(cant:byte):byte;
var
   canti:byte;
begin
     canti:=cant;
     while (canti>45) do
          begin
              canti:=canti-45;
          end;
     asientos:=45-canti;
end;

function ImporteTotal (cant:byte; dest:byte; temp:boolean): single;
    var
       cantidad:byte;
       destino:byte;
       tempo: boolean;
       sobran: byte;
       totalsobran : single;
       boleto: single;
       total:single;
       aux :single;

    begin
         cantidad:=cant;
         tempo:=temp;
         destino:=dest;
         sobran:=0;
       while (cantidad>45) do
             begin
                  cantidad:=cantidad-45;
             end;
       sobran:=45-cantidad;

       case destino of
            1:boleto:=200;
            2:boleto:=150;
            3:boleto:=500;
            4:boleto:=350;
       end;

       aux:= (boleto*40)/100;
       totalsobran:= sobran*aux;

       total:= (cant*boleto);
       total:=total+totalsobran;

       if (tempo) then
          begin
           aux:=(total*20)/100;
           total:=total+aux;
          end;
       ImporteTotal:=total;
    end;
procedure GuardarAlumno(alum:Alumno;var alu:ArchAlum);
    begin
         assign(alu,'Alumno.dat');
         {$I-}
         reset (alu);
         if (IORESULT<>0) then
           rewrite(alu)
         else
           seek(alu,FILESIZE(alu));
         {$I+}
         write(alu,alum);
         close (alu);
    end;
procedure GuardarColegio(cole:Institucion;var col:ArchInst);
    begin
         assign(col,'Colegio.dat');
         {$I-}
         reset (col);
         if (IORESULT<>0) then
           rewrite(col)
         else
           seek(col,FILESIZE(col));
         {$I+}
         write(col,cole);
         close (col);
    end;
function Titulo(var col:ArchInst;pos:byte):byte;
   var
      cole:Institucion;
      destino:string[10];
   begin
        assign(col,'Colegio.dat');
        reset(col);
        seek(col,pos-1);
        read(col,cole);
            case cole.CodDest of
                1: destino:='Aquarium';
                2: destino:='M. Marino';
                3: destino:='Cataratas';
                4: destino:='V. C. Paz';
            end;
        write('Institucion: ',cole.Nombre,'  Destino: ',destino);
        write('  Fecha: ',cole.Fecha mod 100,'/',(cole.Fecha div 100) mod 100);
        writeln('/',cole.fecha div 10000);
        writeln('');
        writeln('');
        titulo:=cole.CantAlum;
        close(col);
   end;
procedure Leer(var alu:ArchAlum;var col:ArchInst);
    var
       alum:Alumno;
       cole:Institucion;
       aux:Institucion;
       tecla:char;
       import: single;
       cant:byte;
       cod:byte;
       contpos:byte;
    begin
         cod:=0;
         contpos:=1;
         cole.CantAlum:=0;
         assign(alu,'Alumno.dat');
         reset(alu);
         assign(col,'Colegio.dat');
         reset(col);
         while ((not EOF(alu))) do
            begin
                 clrscr;
                 cant:=Titulo(col,contpos);
                 while(cod < cant) do
                       begin

                           read(alu,alum);
                           writeln(alum.Dni,'  ',alum.ApNom);
                           if not(cole.CantAlum=0) then
                             aux:=cole;
                           assign(col,'Colegio.dat');
                           reset(col);
                           seek(col,contpos-1);
                           read(col,cole);
                           inc(cod);
                           inc(contpos);
                       end;
                 cod:=0;
                 writeln('Cantidad total de alumnos:  ',aux.CantAlum);
                 writeln('Cantidad total de asientos vacios:  ',asientos(aux.CantAlum));
                 import:=ImporteTotal(cole.CantAlum,cole.CodDest,Temporada(aux.Fecha));
                 writeln('Importe Neto del viaje:  ', import:0:2);
                 writeln('Descuento  ',Descuento(cole.CantAlum,import):0:2);
                 gotoxy(100,100);
                 write('Presione ENTER para continuar');
                 readln(tecla);
            end;
         close(alu);
         close(col);
    end;

var
   alum : Alumno;
   cole : Institucion;
   col: ArchInst;
   alu: ArchAlum;
   vacios : byte;
   importe : single;
   desc : single;
   nomaux : string[30];
   nomalum : string[30];
   cont : byte;
   ped: byte;
begin
     clrscr;
     writeln('Bienvenido a AGENCIA DE VIAJES TURISMAR');
     writeln('');
     write('Ingrese el nombre de la institucion: ');
     read(nomaux);
     writeln('');
     ped:=0;
     while (nomaux<>'fin') do
           begin

                cole.Nombre := nomaux;
                write('Ingrese la cantidad de alumnos: ');
                readln(cole.CantAlum);
                writeln('');
                write('Ingrese Codigo de Destino: ');
                readln(cole.CodDest);
                writeln('');
                write('Ingrese Fecha del Viaje: ');
                readln(cole.Fecha);
                writeln('');
                cole.CodPedido:=ped;
                while (cont < cole.CantAlum) do
                      begin
                           clrscr;
                           alum.CodPedido:=ped;
                           write('Ingrese el documento: ');
                           readln(alum.Dni);
                           writeln('');
                           write('Ingrese Apellido y Nombre: ');
                           readln(nomalum);
                           writeln('');
                           alum.ApNom := nomalum;
                           write('Ingrese Edad: ');
                           readln(alum.Edad);
                           inc(cont);
                           GuardarColegio(cole,col);
                           GuardarAlumno(alum,alu);
                      end;
                inc(ped);
                cont:=0;
                clrscr;
                writeln('Bienvenido a AGENCIA DE VIAJES TURISMAR');
                writeln('');
                write('Ingrese el nombre de la institucion: ');
                read(nomaux);
                writeln('');
           end;
           Leer(alu,col);
           assign(alu,'Alumno.dat');
           rewrite(alu);
           assign(col,'Colegio.dat');
           rewrite(col);
end.