SELECT u.id, u.username, u.role_id, uP.fullname, uP.email, uP.phone, uP.gender, uP.date_of_birth, uP.avatar ,r.name  AS role_name, password
FROM users u 
JOIN user_profile uP ON u.id = uP.user_id  
JOIN role r 
    ON u.role_id = r.id
    Where u.id=1
