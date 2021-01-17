create schema abaybyra;
use abaybyra;

create table validacoes (
	validacao_id int auto_increment,
	email_escola varchar(70) not null, 
	codigo_escola varchar(100) not null unique,
	data_contrato timestamp not null default current_timestamp, 
	status_cadastro bool not null default false,
	
	primary key(validacao_id),
	index idx_validacoes_cod (email_escola)
);

create table logins(
	login_id int auto_increment,
	email varchar(70) unique not null, 
	senha varchar(100) not null, 
	tipo_usuario char(1) not null,
	conta_ativa bool default true not null,
	-- tipo: E  - escola, P - professor, A - aluno
	
	primary key (login_id),
	index idx_logins_email (email)
);

create table escolas (
	escola_id int auto_increment,
	nome varchar(100) not null,
	email varchar(70) unique not null, 
	senha varchar(100) not null, 
	codigo_escola varchar(50) unique not null, 
	logradouro varchar(150) not null,
	numero int unsigned not null, 
	complemento varchar(30),
	bairro varchar(50) not null,
	cidade varchar(60) not null, 
	estado varchar(30) not null, 
	cep char(9) not null,
	telefone char(13) not null,
	telefone_2 char(13), 
	publica bool not null, 
	data_cadastro timestamp not null default current_timestamp,
	
	primary key (escola_id),
	index idx_escolas_email (email)
);

create table alunos(
	aluno_id int auto_increment,
	email varchar(70) unique not null, 
	senha varchar(100) not null,
	turma int unsigned not null,
	escola_id int not null,
	nome varchar(100) not null, 
	data_nascimento date not null, 
	data_cadastro timestamp not null default current_timestamp,
	
	primary key (aluno_id),
	foreign key (escola_id) references escolas(escola_id),
	index idx_alunos_email(email)
	
	);
	

create table professores (
	professor_id int auto_increment,
	nome varchar(100) not null, 
	email varchar(70) unique not null, 
	senha varchar(100) not null, 
	disciplina varchar(30) not null,
	data_cadastro timestamp not null default current_timestamp, 
	
	primary key (professor_id),
	index idx_professores_email (email)
);


create table turmas (
	escola_id int not null,
	professor_id int not null, 
	turma_num int unsigned not null, 
	
	primary key (escola_id, professor_id, turma_num),
	
	foreign key (professor_id) references professores(professor_id), 
	foreign key (escola_id) references escolas(escola_id)
);

create table escola_professor(
	escola_id int not null, 
	professor_id int not null,
	
	primary key(escola_id, professor_id),
	foreign key (escola_id) references escolas(escola_id),
	foreign key (professor_id) references professores (professor_id)
);

delimiter $

create trigger trg_create_login_alunos after insert on alunos
for each row
	begin
		insert into logins(email, senha, tipo)
		values (new.email, new.senha, 'A');
	end$

create trigger trg_create_login_profs after insert on professores
for each row
	begin
		insert into logins(email, senha, tipo)
		values (new.email, new.senha, 'P');
	end$

create trigger trg_create_login_escola after insert on escolas
for each row
	begin
		insert into logins(email, senha, tipo)
		values (new.email, new.senha, 'E');
	end$


create trigger trg_validacao after insert on escolas
for each row
	begin
		update validacoes set status_cadastro = true 
		where email = new.email;
	end$
	
delimiter ;



















	