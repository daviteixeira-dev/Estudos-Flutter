<?php

    $servername = "127.0.0.1";
    $username = "root";
    $password = ""; 
    $dbname = "crediariodb";
    $table = "Funcionario"; //Vamos criar uma tabela chamada funcionarios.

    //obteremos ações do aplicativo para realizar operações no banco de dados.
    $action = $_POST["action"];

    // Criar conecção
    $conn = new mysqli($servername, $username, $password, $dbname);
    // Checar Conecção
    if($conn->connect_error){
        die("Falha na Conecção: " . $conn->connect_error);
        return;
    }

    //Se a coneccção estiver ok...
    //Se o aplicativo enviar uma ação para criar tabela ...
    if("CREATE_TABLE" == $action){
        $sql = "CREATE TABLE IF NOT EXISTS $table (
             id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
             primeiro_nome VARCHAR(30) NOT NULL,
             ultimo_nome VARCHAR(30) NOT NULL,
             )";
        
        if($conn->query($sql) === TRUE){
            //Envie de volta uma menssagem de sucesso
            echo "Sucesso!";
        }else{
            echo "Erro";
        }

        $conn->close();
        return;
    }

    // Obter todos os registros de funcionários do banco de dados.
    if("GET_ALL" == $action){
        $db_data = array();
        $sql = "SELECT id, primeiro_nome, ultimo_nome FROM $table ORDER BY id DESC";
        $result = $conn->query($sql);
        if($result->num_rows > 0){
            while($row = $result->fetch_assoc()){
                $dbdata[]= $row;
            }
            //Envie de volta os registros completos como um json.
            echo json_encode($dbdata);
        }else{
            echo "Erro!";
        }
        $conn->close();
        return;
    }

    // Adicionar funcionarios.
    if("ADD_EMP" == $action){
        $primeiro_nome = $_POST["primeiro_nome"];
        $ultimo_nome = $_POST["ultimo_nome"];
        $sql = "INSERT INTO $table (primeiro_nome, ultimo_nome) VALUES ('$primeiro_nome', '$ultimo_nome')";
        $result = $conn->query($sql);
        echo "Sucesso!";
        //$conn->close();
        return;
    }

    // Atualiza um funcioonario
    if("UPDATE_EMP" == $action){
        // Aplicação ira postar esse valor no servidor.
        $emp_id = $_POST['$emp_id'];
        $primeiro_nome = $_POST["primeiro_nome"];
        $ultimo_nome = $_POST["ultimo_nome"];
        $sql = "UPDATE $table SET primeiro_nome = '$primeiro_nome', ultimo_nome = '$ultimo_nome' WHERE id = $emp_id)";
        if($conn->query($sql) === TRUE){
            echo "Sucesso!";
        }else{
            echo "Erro!";
        }
        $conn->close();
        return;
    }

    // Deletar um funcionario.
    if('DELETE_EMP' == $action){
        $emp_id = $_POST['$emp_id'];
        $sql = "DELETE FROM $table WHERE id = $emp_id"; // Não precisa de aspas quando o id é um inteiro.
        if($conn->query($sql) === TRUE){
            echo "Sucesso!";
        }else{
            echo "Erro!";
        }
        $conn->close();
        return;
    }

?>