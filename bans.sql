CREATE TABLE IF NOT EXISTS vulcan_bans (
    id INT AUTO_INCREMENT PRIMARY KEY,          
    user_id VARCHAR(255) NOT NULL,              
    steam VARCHAR(255),                         
    ip VARCHAR(255),                            
    discord VARCHAR(255),                       
    license VARCHAR(255),                       
    xbl VARCHAR(255),                           
    live VARCHAR(255),                          
    reason TEXT,                                
    banned_by VARCHAR(255),                     
    banned_until TIMESTAMP,                     
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
);
