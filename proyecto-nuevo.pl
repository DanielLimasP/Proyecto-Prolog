%declaracion de librerias

:-use_module(library(pce)).
:-use_module(library(pce_style_item)).

% metodo principal para iniciar la interfaz grafica, declaracion de
% botones, labels, y la pocicion en pantalla.
inicio:-
	new(Menu, dialog('Analisis de COVID 19, Gripe o Influenza', size(1000,800))),
	new(L,label(nombre,'ESTE CUESTIONARIO NO REEMPLAZA UN DIAGNOSTICO PROFESIONAL')),
	new(A,label(nombre,'Progamacion Logica y Funcional')),
	new(@texto,label(nombre,'Responde un breve cuestionario para diagnosticar tu salud')),
	new(@respl,label(nombre,'')),
	new(Salir,button('Salir',and(message(Menu, destroy),message(Menu,free)))),
	new(@boton,button('Realizar cuestionario',message(@prolog,botones))),


	send(Menu,append(L)),new(@btncarrera,button('Diagnostico?')),
	send(Menu,display,L,point(125,20)),
	send(Menu,display,A,point(80,360)),
	send(Menu,display,@boton,point(100,150)),
	send(Menu,display,@texto,point(20,100)),
	send(Menu,display,Salir,point(20,400)),
	send(Menu,display,@respl,point(20,130)),
	send(Menu,open_centered).

%Diagnosticos

diagnosticos('Usted puede tener COVID:
	Le recomendamos que tanto usted como toda su familia se queden en casa de manera
	obligatoria, ya que al salir podria estar poniendo en riesgo de contagio
	a otras personas. Llame al 911 para que expertos le hagan el examen correspondiente
	y asi poder confirmar su diagnostico. '):-covid,!.

diagnosticos('Usted puede tener Gripe:
        Le recomendamos quedarse en casa, descansa, recordar no automedicarse,
	beber abundantes liquidos, seguir las medidas higienicas,
	si llega a sentirse peor, acuda con un profesional.'):-gripe,!.

diagnosticos('Usted puede tener Influenza:
	Le recomendamos quedarse en casa, lavate las manos frecuentemente, evita
	cambios de temperatura bruscos, si estornuda cubrete con el antebrazo,
	si usas pañuelo desechable tiralo inmediatemente, si llegas a sentirte peor
	acude con un profesional.'):-influenza,!.

diagnosticos('Su diagnostico no ha resultado ser COVID, Gripe o Influenza, por lo cual
        le recomendamos acudir con un profesional medico en caso de presentar sintomas
	o sentirse mal. Es extremadamente recomendable que se quede en casa, que
	haga caso de las recomendaciones sanitarias y que no se automedique.').

% preguntas para resolver determinar el diagnostico con su respectivo
% identificador de falla

covid:- dificultad_respirar,
	pregunta('has tenido fiebre?'),
	pregunta('te has sentido fatigado? '),
	pregunta('has tenido tos?'),
	pregunta('has tenedio dolor corporal? '),
	pregunta('has tenido dolor de garganta?'),
	pregunta('has tenido dolor de cabeza?').

gripe:- estornudos,
	pregunta('te has sentido fatigado? '),
	pregunta('has tenido tos?'),
	pregunta('has tenedio dolor corporal? '),
	pregunta('has tenido dolor de garganta?'),
	pregunta('has presentado congestion nasal?').


influenza:- fiebre_subita,
	pregunta('te has sentido fatigado? '),
	pregunta('has tenido tos?'),
	pregunta('has tenedio dolor corporal? '),
	pregunta('has tenido dolor de garganta?'),
	pregunta('has tenido dolor de cabeza?'),
	pregunta('has presentado congestion nasal?'),
	pregunta('has tenido diarrea subita?').

% identificador de diagnosticos que dirige a las preguntas
% correspondientes

dificultad_respirar:-pregunta('has tenido dificultades para respirar ultimamente?'),!.
estornudos:-pregunta('has tenido estornudos?'),!.
fiebre_subita:-pregunta('has presentado fiebre subita?'),!.

% proceso del diagnostico basado en preguntas de si y no, cuando el
% usuario dice si, se pasa a la siguiente pregunta del mismo ramo, si
% dice que no se pasa a la pregunta del siguiente ramo

:-dynamic si/1,no/1.
preguntar(Problema):- new(Diag,dialog('Diagnostico')),
     new(Lbl2,label(texto,'Responde las siguientes preguntas')),
     new(Lbl,label(prob,Problema)),
     new(Btn1,button(si,and(message(Diag,return,si)))),
     new(Btn2,button(no,and(message(Diag,return,no)))),

         send(Diag,append(Lbl2)),
	 send(Diag,append(Lbl)),
	 send(Diag,append(Btn1)),
	 send(Diag,append(Btn2)),

	 send(Diag,default_button,si),
	 send(Diag,open_centered),get(Diag,confirm,Answer),
	 write(Answer),send(Diag,destroy),
	 ((Answer==si)->assert(si(Problema));
	 assert(no(Problema)),fail).

% cada vez que se conteste una pregunta la pantalla se limpia para
% volver a preguntar

pregunta(S):-(si(S)->true; (no(S)->false; preguntar(S))).
limpiar :- retract(si(_)),fail.
limpiar :- retract(no(_)),fail.
limpiar.

% proceso de eleccion de acuerdo al diagnostico basado en las preguntas
% anteriores

botones :- lim,
	send(@boton,free),
	send(@btncarrera,free),
	diagnosticos(Diagnostico),
	send(@texto,selection('Su diagnostico es: ')),
	send(@respl,selection(Diagnostico)),
	new(@boton,button('Inicia procedimiento medico',message(@prolog,botones))),
        send(Menu,display,@boton,point(40,50)),
        send(Menu,display,@btncarrera,point(20,50)),
limpiar.
lim :- send(@respl, selection('')).








