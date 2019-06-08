var
   name:string[30];
begin
     write('Ingrese nombre ');
     read(name);
     writeln;
     writeln('el nombre que ingreso fue: ',name);

     repeat
           write('Ingrese nombre ');
           read(name);
           writeln;
           writeln('el nombre que ingreso fue: ',name);
     until (0<1);
end.