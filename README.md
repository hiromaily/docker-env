# docker-env
docker-env is to create new development environment using Docker.


## Prerequisite
Install Docker.

## projects directory

### 0_db.sh
Create redis and mysql environment.

### 1_go_book.sh
Create ```go-book-teacher``` git repository's environment from ```golang:1.6``` images.  
[go-book-teacher](https://github.com/hiromaily/go-book-teacher)  

### 2_go_book_dockerfile.sh
Create ```go-book-teacher``` git repository's environment from Dockerfile based on ```golang:1.6``` images.

### 3_go_book_compose.sh
Create ```go-book-teacher``` git repository's environment from docker-compose.yml based on ```golang:1.6``` images.

### 4_go_web.sh
Create ```go-gin-wrapper``` git repository's environment from ```golang:1.6``` images.  
[go-gin-wrapper](https://github.com/hiromaily/go-gin-wrapper)  

### 5_go_web_dockerfile.sh
Create ```go-gin-wrapper``` git repository's environment from Dockerfile based on ```golang:1.6``` images.

### 6_go_web_compose.sh
Create ```go-gin-wrapper``` git repository's environment from docker-compose.yml based on ```golang:1.6``` images.

### 7_py_book_dockerfile.sh
Create ```py-book-teacher``` git repository's environment from Dockerfile based on ```python:3.5``` images.  
(repsitory data is copied to container)  
[py-book-teacher](https://github.com/hiromaily/py-book-teacher)  

### 8_py_book_dockerfile2.sh
Create ```py-book-teacher``` git repository's environment from Dockerfile based on ```python:3.5``` images.  
(repsitory data is mounted to container)  

### 9_reset.sh
Clean created images and containers.

