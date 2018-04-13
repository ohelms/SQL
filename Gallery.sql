DROP TABLE service_invoices PURGE;
DROP TABLE sales_invoices PURGE;
DROP TABLE consignments PURGE;
DROP TABLE purchases PURGE;
DROP TABLE painting PURGE;
DROP TABLE photograph PURGE;
DROP TABLE sculpture PURGE;
DROP TABLE artworks PURGE;
DROP TABLE vendors PURGE;
DROP TABLE services PURGE;
DROP TABLE preferences PURGE;
DROP TABLE customers PURGE;
DROP TABLE employees PURGE;
DROP VIEW sales_inv_ph;
DROP VIEW sales_inv_pa;
DROP VIEW sales_inv_sculp;
DROP VIEW service_inv;
DROP VIEW purchase_agreement_ph;
DROP VIEW purchase_agreement_pa;
DROP VIEW purchase_agreement_sculp;
DROP VIEW consignment_agreement_pa;
DROP VIEW consignment_agreement_ph;
DROP VIEW consignment_agreement_sculp;
DROP VIEW query_a;
DROP VIEW query_d;
DROP VIEW query_f;
DROP VIEW query_g_a;
DROP VIEW query_g_b;
DROP VIEW query_h;
DROP VIEW query_i;
DROP VIEW query_j;
DROP VIEW query_c;










CREATE TABLE vendors
(vendor_id 			NUMBER(6) CONSTRAINT vendor_vid_pk PRIMARY KEY,
vendor_organization 		VARCHAR2(30),
vendor_type			VARCHAR2(10) CHECK(vendor_type IN('Auction','Gallery','Artist'))NOT NULL,
vendor_rep_fname 		VARCHAR(15),
vendor_rep_lname 		VARCHAR(15),
vendor_street 			VARCHAR2(30),
vendor_city 			VARCHAR2(30),
vendor_state 			VARCHAR2(2),
vendor_zip 			VARCHAR2(5),
vendor_phone 			VARCHAR2(15),
vendor_fax 			VARCHAR2(15));




CREATE TABLE artworks
(artwork_id 			NUMBER(6) PRIMARY KEY,
artwork_title			VARCHAR2(30) NOT NULL,
short_description 		VARCHAR2(30),
artist_first_name		VARCHAR2(15),
artist_last_name		VARCHAR2(15),
date_of_creation		DATE,
height				NUMBER(3),
width				NUMBER(3),
length				NUMBER(3),
place_of_origin			VARCHAR2(30),
country_of_origin		VARCHAR2(15),
category			VARCHAR2(15) CHECK(category IN('Painting','Photograph','Sculpture'))NOT NULL,
description			VARCHAR2(100),
suggested_price			NUMBER(11,2) NOT NULL,
min_selling_price		NUMBER(11,2) NOT NULL,
status				VARCHAR2(10) CHECK(status IN('For Sale','Sold','Returned'))NOT NULL);

CREATE TABLE painting
(artwork_id 			NUMBER(6) PRIMARY KEY REFERENCES artworks(artwork_id),
media				VARCHAR2(10) NOT NULL,
style				VARCHAR2(20) NOT NULL,
frame				VARCHAR2(3) CHECK(frame IN('Yes','No'))NOT NULL);

CREATE TABLE photograph
(artwork_id 			NUMBER(6) PRIMARY KEY REFERENCES artworks(artwork_id),
art_type			VARCHAR2(15) CHECK(art_type IN('Black and White','Color'))NOT NULL,
signed				VARCHAR2(3) CHECK(signed IN('Yes','No'))NOT NULL,
limited				VARCHAR2(3) CHECK(limited IN('Yes','No'))NOT NULL,
numbered			NUMBER(3),
frame				VARCHAR2(3) CHECK(frame IN('Yes','No'))NOT NULL);

CREATE TABLE sculpture
(artwork_id 			NUMBER(6) PRIMARY KEY REFERENCES artworks(artwork_id),
sculpture_type			VARCHAR2(15) CHECK(sculpture_type IN('Free Standing','Relief'))NOT NULL,
weight				NUMBER(6),
material			VARCHAR2(15),
base				VARCHAR2(3) CHECK(base IN('Yes','No'))NOT NULL);




CREATE TABLE employees
(empl_id 			NUMBER (6) PRIMARY KEY,
empl_first_name			VARCHAR2(15) NOT NULL,
empl_last_name 			VARCHAR2(15) NOT NULL,
empl_type			VARCHAR2(20) CHECK(empl_type IN('Sales Associate','Service Associate','Manager'))NOT NULL,
date_of_hire			DATE,
status				VARCHAR2(30),
salary				NUMBER(7,2),
commission 			NUMBER(5,2),
manager_id			NUMBER(6),
				CHECK((empl_type='Manager' AND manager_id IS NOT NULL) OR
				(empl_type!='Manager' AND manager_id IS NULL)),
				CHECK((empl_type='Sales Associate' AND commission IS NOT NULL) OR
				(empl_type!='Sales Associate' AND commission IS NULL)));  




CREATE TABLE customers
(customer_id 			NUMBER(6) CONSTRAINT customer_cid_pk PRIMARY KEY,
customer_first_name		VARCHAR2(15) NOT NULL,
customer_last_name		VARCHAR2(15) NOT NULL,
customer_street 		VARCHAR2(30),
customer_city 			VARCHAR2(30),
customer_state 			VARCHAR2(2),
customer_zip 			VARCHAR2(5),
customer_phone 			VARCHAR2(15),
customer_email			VARCHAR2(30));

CREATE TABLE preferences
(preference_id 			NUMBER(6) PRIMARY KEY,
artwork_type			VARCHAR2(15) CHECK(artwork_type IN('Painting','Photograph','Sculpture')),
artwork_name			VARCHAR2(30),
artwork_description		VARCHAR2(100),
customer_id			NUMBER(6) CONSTRAINT preference_cid_fk REFERENCES
					customers(customer_id));




CREATE TABLE consignments
(consignment_id 		NUMBER(6) CONSTRAINT consignment_cid_pk PRIMARY KEY,
date_of_consignment 		DATE,
date_of_start 			DATE,
date_of_end 			DATE,
commission_pct			NUMBER(5,2),
sales_agent_pct 		NUMBER(5,2),
vendor_id 			NUMBER(6) CONSTRAINT consignment_vid_FK 
					REFERENCES vendors(vendor_id),
manager_id			NUMBER(6) NOT NULL,
artwork_id			NUMBER(6) CONSTRAINT consignment_aid_FK 
					REFERENCES artworks(artwork_id));




CREATE TABLE purchases
(purchase_id 			NUMBER(6) CONSTRAINT purchase_pid_pk PRIMARY KEY,
date_of_purchase 		DATE NOT NULL,
purchase_amount 		NUMBER(11,2) NOT NULL,
shipping 			NUMBER(7,2),
misc 				NUMBER(7,2),
vendor_id 			NUMBER(6) CONSTRAINT putchase_vid_FK 
					REFERENCES vendors(vendor_id),
manager_id			NUMBER(6) NOT NULL,
artwork_id			NUMBER(6) CONSTRAINT purchase_aid_FK 
					REFERENCES artworks(artwork_id));




CREATE TABLE sales_invoices
(sales_invoice_id 		NUMBER(6) CONSTRAINT sales_invoice_sid_pk PRIMARY KEY,
date_of_invoice			DATE NOT NULL,
sales_price      		NUMBER(11,2),
shipping_price 		 	NUMBER(7,2),
misc_price 			NUMBER(7,2),
date_of_approval		DATE,
manager_id			NUMBER(6),
customer_id			NUMBER(6) CONSTRAINT sales_invoice_cid_fk 
					REFERENCES customers(customer_id),
empl_id				NUMBER(6) CONSTRAINT sales_invoice_said_fk 
					REFERENCES employees(empl_id), 
artwork_id	 		NUMBER(6) CONSTRAINT sales_invoice_pid_fk 
					REFERENCES artworks(artwork_id),
				CHECK((sales_price>=5000 AND manager_id IS NOT NULL) 
				OR (sales_price < 5000 AND manager_id IS NULL)),
				CHECK((sales_price>=5000 AND date_of_approval IS NOT NULL) 
				OR (sales_price < 5000 AND date_of_approval IS NULL)));




CREATE TABLE services
(service_id 			NUMBER(6) PRIMARY KEY,
service_type			VARCHAR2(30) CHECK(service_type IN('Framing','Framing','Cleaning','Restoration','Other'))NOT NULL,
service_price			NUMBER(7,2),
				CHECK((service_type='Framing' AND service_price = 0.45) OR
				(service_type='Cleaning' AND service_price = 3.00) OR
				(service_type='Restoration' AND service_price = 5.00) OR
				(service_type='Other' AND service_price IS NOT NULL))); 

CREATE TABLE service_invoices
(service_invoice_id 		NUMBER(6) CONSTRAINT service_invoice_sid_pk PRIMARY KEY,
date_of_invoice			DATE NOT NULL,
shipping_price 		 	NUMBER(7,2),
misc_price 			NUMBER(9,2),
artwork_id	 		NUMBER(6) CONSTRAINT service_invoice_aid_fk 
					REFERENCES artworks(artwork_id),
empl_id				NUMBER(6) CONSTRAINT service_invoice_seid_fk 
					REFERENCES employees(empl_id),
customer_id			NUMBER(6) CONSTRAINT service_invoice_cid_fk 
					REFERENCES customers(customer_id),
service_id	 		NUMBER(6) CONSTRAINT service_invoice_serid_fk 
					REFERENCES services(service_id));

















































INSERT INTO vendors (vendor_id, vendor_organization, vendor_type, vendor_rep_fname, vendor_rep_lname,
		     vendor_street, vendor_city, vendor_state, vendor_zip, vendor_phone, vendor_fax)
VALUES 		    (000001, 'Jackson Artworks', 'Gallery', 'Michael', 'Jackson',
	             '1032 Dorsy Dr.', 'Los Angeles','CA','93252','9236248322', '9256348332');

INSERT INTO vendors (vendor_id, vendor_organization, vendor_type, vendor_rep_fname, vendor_rep_lname,
		     vendor_street, vendor_city, vendor_state, vendor_zip, vendor_phone, vendor_fax)
vALUES      	    (000002, 'Bid Vibes', 'Auction', 'Patrick', 'Smallson',
	             '151 Bald St.', 'San Francisco','CA','93111','9224894528', NULL);

INSERT INTO vendors (vendor_id, vendor_organization, vendor_type, vendor_rep_fname, vendor_rep_lname,
		     vendor_street, vendor_city, vendor_state, vendor_zip, vendor_phone, vendor_fax)
vALUES      	    (000003, NULL, 'Artist', 'Jeff', 'Simpson',
	             '132 Springfield St.', 'New York','NY','92122','9212342328', NULL);

INSERT INTO vendors (vendor_id, vendor_organization, vendor_type, vendor_rep_fname, vendor_rep_lname,
		     vendor_street, vendor_city, vendor_state, vendor_zip, vendor_phone, vendor_fax)
vALUES      	    (000004, 'Auctionry', 'Auction', 'Brian', 'Hoffman',
	             '956 Holdings Dr.', 'San Francisco','CA','93892','9131423428', '2374134971');

INSERT INTO vendors (vendor_id, vendor_organization, vendor_type, vendor_rep_fname, vendor_rep_lname,
		     vendor_street, vendor_city, vendor_state, vendor_zip, vendor_phone, vendor_fax)
vALUES      	    (000005, 'Italian Art', 'Gallery', 'Marco', 'Clancy',
	             '3126 Venice Dr.', 'New York','NY','15519','9245245628', NULL);




INSERT INTO artworks (artwork_id, artwork_title, short_description, artist_first_name, artist_last_name, date_of_creation,
		      height, width,length, place_of_origin, country_of_origin, category, description, suggested_price,
		      min_selling_price, status)
VALUES		     (000001, 'Mona Lisa','Old Painting', 'Leonardo', 'Da Vinci','03-APR-1503',
		      30, 1, 21, 'Florence', 'Italy', 'Painting','Long Description', 5300000,
		      5200000, 'For Sale');

INSERT INTO artworks (artwork_id, artwork_title, short_description, artist_first_name, artist_last_name, date_of_creation,
		      height, width,length, place_of_origin, country_of_origin, category, description, suggested_price,
		      min_selling_price, status)
VALUES		     (000002, 'Venus De Milo','Old Sculpture', 'Alexandros', 'Antioch', NULL,
		      72, 15 , 23, 'Athens', 'Greece', 'Sculpture','Long Description', 7800000,
		      7700000, 'Sold');

INSERT INTO artworks (artwork_id, artwork_title, short_description, artist_first_name, artist_last_name, date_of_creation,
		      height, width,length, place_of_origin, country_of_origin, category, description, suggested_price,
		      min_selling_price, status)
VALUES		     (000003, 'Classic Camaro','New Picture', 'George', 'Brady','01-JUN-2003',
		      6, 1, 4, 'Dallas', 'United State', 'Photograph','Long Description', 70000,
		      60000, 'Returned');

INSERT INTO artworks (artwork_id, artwork_title, short_description, artist_first_name, artist_last_name, date_of_creation,
		      height, width,length, place_of_origin, country_of_origin, category, description, suggested_price,
		      min_selling_price, status)
VALUES		     (000004, 'Statue of David','David', 'Michelangelo', 'Di Lodovico', NULL,
		      204, 32, 50, 'Florence', 'Italy', 'Sculpture','Long Description', 10000000,
		      10000000, 'For Sale');

INSERT INTO artworks (artwork_id, artwork_title, short_description, artist_first_name, artist_last_name, date_of_creation,
		      height, width,length, place_of_origin, country_of_origin, category, description, suggested_price,
		      min_selling_price, status)
VALUES		     (000005, 'Lion in the Wild','African Lion', 'Logan', 'Brown', '10-SEP-1989',
		      10, 1, 6, 'Cape Cod', 'South Africa', 'Photograph','Long Description', 1500,
		      1000, 'Sold');

INSERT INTO artworks (artwork_id, artwork_title, short_description, artist_first_name, artist_last_name, date_of_creation,
		      height, width,length, place_of_origin, country_of_origin, category, description, suggested_price,
		      min_selling_price, status)
VALUES		     (000006, 'Mikey Mouse','Cartoon character', 'Sarah', 'Patkinson', '14-NOV-1962',
		      20, 1, 14, 'Los Angeles', 'United States', 'Painting','Long Description', 2700,
		      2100, 'Sold');

INSERT INTO artworks (artwork_id, artwork_title, short_description, artist_first_name, artist_last_name, date_of_creation,
		      height, width,length, place_of_origin, country_of_origin, category, description, suggested_price,
		      min_selling_price, status)
VALUES		     (000007, 'Einstein','Physicist', 'Lori', 'Morgan', '27-NOV-1950',
		      30, 2, 21, 'San Francisco', 'United States', 'Painting','Long Description', 5100,
		      5000, 'Sold');


INSERT INTO artworks (artwork_id, artwork_title, short_description, artist_first_name, artist_last_name, date_of_creation,
		      height, width,length, place_of_origin, country_of_origin, category, description, suggested_price,
		      min_selling_price, status)
VALUES		     (000008, 'Pumpkin Patch','Happy Halloween', 'Martha', 'Stewart', '30-OCT-2003',
		     12, 1, 8, 'San Luis Obispo', 'United States', 'Photograph','Long Description', 1300,
		      1100, 'Sold');

INSERT INTO artworks (artwork_id, artwork_title, short_description, artist_first_name, artist_last_name, date_of_creation,
		      height, width,length, place_of_origin, country_of_origin, category, description, suggested_price,
		      min_selling_price, status)
VALUES		     (000009, 'Baseball Player','Old Sculpture', 'Jack', 'Gordon', '22-NOV-1937',
		     60, 8, 24, 'Nashville', 'United States', 'Sculpture','Long Description', 3400,
		      4000, 'For Sale');




INSERT INTO painting (artwork_id, media, style, frame)
VALUES		     (000001, 'Oil', 'Realism', 'Yes');

INSERT INTO painting (artwork_id, media, style, frame)
VALUES		     (000006, 'Pastel', 'Modernism', 'No');

INSERT INTO painting (artwork_id, media, style, frame)
VALUES		     (000007, 'Watercolor', 'Impressionism', 'Yes');

INSERT INTO photograph (artwork_id, art_type, signed, limited, numbered, frame)
VALUES		     (000003, 'Color', 'Yes','Yes', 1, 'No');

INSERT INTO photograph (artwork_id, art_type, signed, limited, numbered, frame)
VALUES		     (000005, 'Black and White', 'Yes','No', 7, 'No');

INSERT INTO photograph (artwork_id, art_type, signed, limited, numbered, frame)
VALUES		     (000008, 'Color', 'No','No', NULL, 'Yes');

INSERT INTO sculpture (artwork_id, sculpture_type, weight, material, base)
VALUES		     (000002, 'Relief', 2500,'Marble', 'No');

INSERT INTO sculpture (artwork_id, sculpture_type, weight, material, base)
VALUES		     (000004, 'Free Standing', 5500,'Marble', 'Yes');

INSERT INTO sculpture (artwork_id, sculpture_type, weight, material, base)
VALUES		     (000009, 'Free Standing', 1000, 'Gypsum', 'No');



INSERT INTO services (service_id, service_type, service_price)
VALUES		     (000001, 'Framing', 0.45);
INSERT INTO services (service_id, service_type, service_price)
VALUES		     (000002, 'Cleaning', 3.00);
INSERT INTO services (service_id, service_type, service_price)
VALUES		     (000003, 'Restoration', 5.00);
INSERT INTO services (service_id, service_type, service_price)
VALUES		     (000004, 'Other', 2.50);




INSERT INTO employees (empl_id, empl_first_name, empl_last_name, empl_type, date_of_hire, status, salary, commission, manager_id)
VALUES		      (000001, 'Leonard','Martini','Manager','03-FEB-2005', 'Employed', 90000, NULL, 000001);

INSERT INTO employees (empl_id, empl_first_name, empl_last_name, empl_type, date_of_hire, status, salary, commission, manager_id)
VALUES		      (000002, 'Ruth','Rambleson','Manager','10-APR-2007', 'Employed', 80000, NULL, 000002);

INSERT INTO employees (empl_id, empl_first_name, empl_last_name, empl_type, date_of_hire, status, salary, commission, manager_id)
VALUES		      (000003, 'Alan','Wrench','Service Associate','15-JUN-2008', 'Employed', 50000, NULL, NULL);

INSERT INTO employees (empl_id, empl_first_name, empl_last_name, empl_type, date_of_hire, status, salary, commission, manager_id)
VALUES		      (000004, 'Woody','Apple','Service Associate','18-JUL-2008', 'Fired', 50000, NULL, NULL);

INSERT INTO employees (empl_id, empl_first_name, empl_last_name, empl_type, date_of_hire, status, salary, commission, manager_id)
VALUES		      (000005, 'Mark','Mason','Service Associate','28-OCT-2009', 'On Leave', 50000, NULL, NULL);

INSERT INTO employees (empl_id, empl_first_name, empl_last_name, empl_type, date_of_hire, status, salary, commission, manager_id)
VALUES		      (000006, 'Mary','Long','Manager','19-AUG-2010', 'Employed', 75000, NULL, 000003);

INSERT INTO employees (empl_id, empl_first_name, empl_last_name, empl_type, date_of_hire, status, salary, commission, manager_id)
VALUES		      (000007, 'Joe','Monet','Sales Associate','07-DEC-2010', 'Employed', 60000, 0.04, NULL);

INSERT INTO employees (empl_id, empl_first_name, empl_last_name, empl_type, date_of_hire, status, salary, commission, manager_id)
VALUES		      (000008, 'Lance','Powers','Sales Associate','08-MAR-2011', 'Employed', 60000, 0.04, NULL);

INSERT INTO employees (empl_id, empl_first_name, empl_last_name, empl_type, date_of_hire, status, salary, commission, manager_id)
VALUES		      (000009, 'Art','Van Gogh','Sales Associate','03-JAN-2012', 'Employed', 60000, 0.04, NULL); 









INSERT INTO customers (customer_id, customer_first_name, customer_last_name, 
		       customer_street, customer_city, customer_state,
	    	       customer_zip, customer_phone, customer_email)
VALUES		      (000001, 'Jack', 'Sahn', 
 		      '8997 Higuera Street', 'San Luis Obispo', 'CA',
		      '93410', '8055654423', 'jsahn@gmail.com');

INSERT INTO customers (customer_id, customer_first_name, customer_last_name,
		       customer_street, customer_city, customer_state,
	    	       customer_zip, customer_phone, customer_email)
VALUES		      (000002, 'Marty', 'Smith', 
		       '1330 Folsom Street', 'San Francisco', 'CA',
		       '93336', '9258572323', 'mmsmith@gmail.com');

INSERT INTO customers (customer_id, customer_first_name, customer_last_name, 
		       customer_street, customer_city, customer_state,
	    	       customer_zip, customer_phone, customer_email)
VALUES		      (000003, 'Sam', 'Stewart', 
                       '8888 Campbell Drive', 'San Jose', 'CA',
                       '93626', '4087976565', 'sstew@gmail.com');

INSERT INTO customers (customer_id, customer_first_name, customer_last_name,
		       customer_street, customer_city, customer_state,
	    	       customer_zip, customer_phone, customer_email)
VALUES		      (000004, 'Roberta', 'Edwards',
                       '9908 Sirius Drive', 'Bakersfield', 'CA',
                       '98756', '7809764476', 'roberta@yahoo.com');

INSERT INTO customers (customer_id, customer_first_name, customer_last_name, 
		       customer_street, customer_city, customer_state,
	    	       customer_zip, customer_phone, customer_email)
VALUES		      (000005, 'Lori', 'Tanes', 
		       '67347 Fremont Boulevard', 'Fremont', 'CA',
                       '94555', '5109086634', 'ltones@gmail.com');

INSERT INTO customers (customer_id, customer_first_name, customer_last_name,
                       customer_street, customer_city, customer_state,
	    	       customer_zip, customer_phone, customer_email)
VALUES		      (000006, 'Damian', 'Jones', 
                       '55543 Music Street', 'Lafayette', 'CA',
                       '94549', '9253434000', 'jonesd@gmail.com');

INSERT INTO customers (customer_id, customer_first_name, customer_last_name,
                       customer_street, customer_city, customer_state,
	    	       customer_zip, customer_phone, customer_email)
VALUES		      (000007, 'Carson', 'Hoyer',
		       '13454 Third Street', 'Oakland', 'CA',
                       '96354', '5108987746', 'choyer@hotmail.com');

INSERT INTO customers (customer_id, customer_first_name, customer_last_name,
                       customer_street, customer_city, customer_state,
	    	       customer_zip, customer_phone, customer_email)
VALUES		      (000008, 'Harry', 'Lorman',
                       '12456 Muggle Avenue', 'Denver', 'CO',
                       '74534', '5656265530', 'hpotter@hogwarts.com');

INSERT INTO customers (customer_id, customer_first_name, customer_last_name, 
                       customer_street, customer_city, customer_state,
	    	       customer_zip, customer_phone, customer_email)
VALUES		      (000009, 'Ron', 'Weasley', 
		       '88546 Diagon Avenue','Riverside', 'CA',
                       '92234', '6265308476', 'rweasley@hogwarts.com');

INSERT INTO customers (customer_id, customer_first_name, customer_last_name,
                       customer_street, customer_city, customer_state,
	    	       customer_zip, customer_phone, customer_email)
VALUES		      (000010, 'Ella', 'Dines', 
                       '76547 Tray Street', 'Los Angeles', 'CA',
                       '97576', '6265306485', 'eddines@gmail.com');




INSERT INTO preferences (preference_id, artwork_type, artwork_name, artwork_description, customer_id)
VALUES		     (000001, 'Photograph', NULL, 'Description',000002);

INSERT INTO preferences (preference_id, artwork_type, artwork_name, artwork_description, customer_id)
VALUES		     (000002, 'Sculpture', 'Description', NULL, 000002);

INSERT INTO preferences (preference_id, artwork_type, artwork_name, artwork_description, customer_id)
VALUES		     (000003, 'Painting', NULL, 'Description', 000005);

INSERT INTO preferences (preference_id, artwork_type, artwork_name, artwork_description, customer_id)
VALUES		     (000004, 'Photograph', 'Description', NULL, 000006);

INSERT INTO preferences (preference_id, artwork_type, artwork_name, artwork_description, customer_id)
VALUES		     (000005, 'Sculpture', 'Description', NULL, 000009);

INSERT INTO preferences (preference_id, artwork_type, artwork_name, artwork_description, customer_id)
VALUES		     (000006, 'Painting', 'Science Project', 'Description', 000009);









INSERT INTO sales_invoices (sales_invoice_id, date_of_invoice, sales_price, shipping_price, misc_price, 
				date_of_approval, manager_id, empl_id, customer_id, artwork_id)
VALUES		     (000001,'18-JUN-2007', 5050, 150, NULL,'20-MAR-2006' ,000003, 000007,000002,000007);

INSERT INTO sales_invoices (sales_invoice_id, date_of_invoice, sales_price, shipping_price, misc_price, 
				date_of_approval, manager_id, empl_id, customer_id, artwork_id)
VALUES		     (000002,'27-MAR-2008', 2300, 175, NULL, NULL, NULL, 000007,000008,000006);

INSERT INTO sales_invoices (sales_invoice_id, date_of_invoice, sales_price, shipping_price, misc_price, 
				date_of_approval, manager_id, empl_id, customer_id, artwork_id)
VALUES		     (000003,'07-APR-2009', 7800000, 600, NULL,'15-MAY 2008', 000001, 000008,000002,000002);

INSERT INTO sales_invoices (sales_invoice_id,date_of_invoice, sales_price, shipping_price, misc_price, 
				date_of_approval, manager_id, empl_id, customer_id, artwork_id)
VALUES		     (000004,'04-MAY-2009', 1200, 200, 50, NULL, NULL, 000008,000006,000005);

INSERT INTO sales_invoices (sales_invoice_id, date_of_invoice, sales_price, shipping_price, misc_price, 
				date_of_approval, manager_id, empl_id, customer_id, artwork_id)
VALUES		     (000005,'15-FEB-2010', 1150, 180, NULL, NULL, NULL, 000008,000007,000008);



INSERT INTO service_invoices (service_invoice_id, date_of_invoice, shipping_price, misc_price, 
				artwork_id, empl_id, customer_id, service_id)
VALUES		     (000001, '25-FEB-2009', 50, NULL, 000006, 000003, 000008, 000001);

INSERT INTO service_invoices (service_invoice_id, date_of_invoice, shipping_price, misc_price,
				 artwork_id, empl_id, customer_id, service_id)
VALUES		     (000002, '10-JAN-2010', 1000, 300, 000002, 000003, 000002,  000003);

INSERT INTO service_invoices (service_invoice_id, date_of_invoice, shipping_price, misc_price,
				 artwork_id, empl_id, customer_id, service_id)
VALUES		     (000003, '05-AUG-2010', NULL, NULL, 000005, 000004, 000006, 000001);

INSERT INTO service_invoices (service_invoice_id, date_of_invoice, shipping_price, misc_price,
				 artwork_id, empl_id, customer_id, service_id)
VALUES		     (000004,'23-MAR-2011', 300, 50, 000007, 000005, 000002, 000002);




INSERT INTO consignments (consignment_id, date_of_consignment, date_of_start, date_of_end, 
			commission_pct, sales_agent_pct, vendor_id, manager_id, artwork_id)
VALUES		     (000001, '01-JUN-2001','06-JUN-2001', '03-AUG-2018', 0.25, 0.02, 000005, 000001, 000001);

INSERT INTO consignments (consignment_id, date_of_consignment, date_of_start, date_of_end, 
			commission_pct, sales_agent_pct, vendor_id, manager_id, artwork_id)
VALUES		     (000002,'29-DEC-2006', '03-JAN-2007', '15-MAR-2010', 0.28, 0.03, 000001, 000001, 000003);

INSERT INTO consignments (consignment_id, date_of_consignment, date_of_start, date_of_end, 
			commission_pct, sales_agent_pct, vendor_id, manager_id, artwork_id)
VALUES		     (000003,'08-FEB-2007', '17-FEB-2007', '03-AUG-2010', 0.20, 0.04, 000003, 000001, 000005);

INSERT INTO consignments (consignment_id, date_of_consignment, date_of_start, date_of_end, 
			commission_pct, sales_agent_pct, vendor_id, manager_id, artwork_id)
VALUES		     (000004,'17-JUN-2013', '25-JUN-2013', '21-SEP-2019', 0.22, 0.01, 000001, 000001, 000009);





INSERT INTO purchases (purchase_id, date_of_purchase, purchase_amount, 
		       shipping, misc, vendor_id, manager_id, artwork_id)
VALUES		     (000001, '21-JUN-2004', 7200000, 15000, 1000, 000004, 000001, 000002);

INSERT INTO purchases (purchase_id, date_of_purchase, purchase_amount,
                       shipping, misc, vendor_id, manager_id, artwork_id)
VALUES		     (000002, '11-MAR-2005', 9000000, 25000, 3500, 000005, 000001, 000004);

INSERT INTO purchases (purchase_id, date_of_purchase, purchase_amount, 
                       shipping, misc, vendor_id, manager_id, artwork_id)
VALUES		     (000003, '08-JUL-2006', 1500, NULL, NULL, 000002, 000001, 000006);

INSERT INTO purchases (purchase_id, date_of_purchase, purchase_amount,
                       shipping, misc, vendor_id, manager_id, artwork_id)
VALUES		     (000004, '28-OCT-2007', 4000, NULL, 100, 000004, 000001, 000007);

INSERT INTO purchases (purchase_id, date_of_purchase, purchase_amount,
		       shipping, misc, vendor_id, manager_id, artwork_id)
VALUES		     (000005, '13-SEP-2008', 500, NULL, NULL, 000001, 000001, 000008);








CREATE OR REPLACE VIEW sales_inv_ph
	(sales_invoice_id,customer_first_name, customer_last_name, 
	customer_street, customer_city, customer_state, 
	customer_zip, customer_phone, customer_email,
	artwork_title, short_description, artist_first_name,
	artist_last_name, date_of_creation, height, width, length,
	place_of_origin, country_of_origin, category, description,
	date_of_invoice, sales_price, shipping_price, misc_price,
	taxes, total, date_of_approval,
	art_type, signed, limited, numbered, frame,
	empl_first_name, empl_last_name,
	manager_first_name, manager_last_name)
AS SELECT
	sai.sales_invoice_id, c.customer_first_name, c.customer_last_name, 
	c.customer_street, c.customer_city, c.customer_state, 
	c.customer_zip, c.customer_phone, c.customer_email,
	a.artwork_title, a.short_description, a.artist_first_name,
	a.artist_last_name, a.date_of_creation, a.height, a.width, a.length,
	a.place_of_origin, a.country_of_origin, a.category, a.description,
	sai.date_of_invoice, sai.sales_price, sai.shipping_price, sai.misc_price,
	sai.sales_price*0.0725, sai.sales_price + NVL(sai.shipping_price,0) + NVL(sai.misc_price,0) + 
	sai.sales_price*0.0725, sai.date_of_approval,
	ph.art_type, ph.signed, ph.limited, ph.numbered, ph.frame,
	e.empl_first_name, e.empl_last_name, 
	m.empl_first_name, m.empl_last_name
FROM 	sales_invoices sai 
JOIN 	artworks a
ON	(sai.artwork_id = a.artwork_id)
JOIN 	customers c
ON	(sai.customer_id = c.customer_id)
JOIN 	photograph ph
ON	(sai.artwork_id = ph.artwork_id)
JOIN 	employees e
ON	(sai.empl_id = e.empl_id)
LEFT JOIN	employees m
ON	(sai.manager_id = m.manager_id);








CREATE OR REPLACE VIEW sales_inv_pa
	(sales_invoice_id,customer_first_name, customer_last_name, 
	customer_street, customer_city, customer_state, 
	customer_zip, customer_phone, customer_email,
	artwork_title, short_description, artist_first_name,
	artist_last_name, date_of_creation, height, width, length,
	place_of_origin, country_of_origin, category, description,
	date_of_invoice, sales_price, shipping_price, misc_price, 
	taxes, total, date_of_approval,
	media, style, frame,
	empl_first_name, empl_last_name,
	manager_first_name, manager_last_name)
AS SELECT
	sai.sales_invoice_id,c.customer_first_name, c.customer_last_name, 
	c.customer_street, c.customer_city, c.customer_state, 
	c.customer_zip, c.customer_phone, c.customer_email,
	a.artwork_title, a.short_description, a.artist_first_name,
	a.artist_last_name, a.date_of_creation, a.height, a.width, a.length,
	a.place_of_origin, a.country_of_origin, a.category, a.description,
	sai.date_of_invoice, sai.sales_price, sai.shipping_price, sai.misc_price,
	sai.sales_price*0.0725,sai.sales_price + NVL(sai.shipping_price,0) + NVL(sai.misc_price,0) + 
	sai.sales_price*0.0725, sai.date_of_approval,
	pa.media, pa.style, pa.frame,
	e.empl_first_name, e.empl_last_name, 
	m.empl_first_name, m.empl_last_name
FROM 	sales_invoices sai 
JOIN 	artworks a
ON	(sai.artwork_id = a.artwork_id)
JOIN 	customers c
ON	(sai.customer_id = c.customer_id)
JOIN 	painting pa
ON	(sai.artwork_id = pa.artwork_id)
JOIN 	employees e
ON	(sai.empl_id = e.empl_id)
LEFT JOIN 	employees m
ON	(sai.manager_id = m.manager_id);






CREATE OR REPLACE VIEW sales_inv_sculp
	(sales_invoice_id, customer_first_name, customer_last_name, 
	customer_street, customer_city, customer_state, 
	customer_zip, customer_phone, customer_email,
	artwork_title, short_description, artist_first_name,
	artist_last_name, date_of_creation, height, width, length,
	place_of_origin, country_of_origin, category, description,
	date_of_invoice, sales_price, shipping_price, misc_price, 
	taxes, total, date_of_approval,
	sculpture_type, weight, material, base,
	empl_first_name, empl_last_name,
	manager_first_name, manager_last_name)
AS SELECT
	sai.sales_invoice_id, c.customer_first_name, c.customer_last_name, 
	c.customer_street, c.customer_city, c.customer_state, 
	c.customer_zip, c.customer_phone, c.customer_email,
	a.artwork_title, a.short_description, a.artist_first_name,
	a.artist_last_name, a.date_of_creation, a.height, a.width, a.length,
	a.place_of_origin, a.country_of_origin, a.category, a.description,
	sai.date_of_invoice, sai.sales_price, sai.shipping_price, sai.misc_price,
	sai.sales_price*0.0725,sai.sales_price + NVL(sai.shipping_price,0) + NVL(sai.misc_price,0) + 
	sai.sales_price*0.0725, sai.date_of_approval,
	sculp.sculpture_type, sculp.weight, sculp.material, sculp.base,
	e.empl_first_name, e.empl_last_name, 
	m.empl_first_name, m.empl_last_name
FROM 	sales_invoices sai 
JOIN 	artworks a
ON	(sai.artwork_id = a.artwork_id)
JOIN 	customers c
ON	(sai.customer_id = c.customer_id)
JOIN 	sculpture sculp
ON	(sai.artwork_id = sculp.artwork_id)
JOIN 	employees e
ON	(sai.empl_id = e.empl_id)
LEFT JOIN 	employees m
ON	(sai.manager_id = m.manager_id);







CREATE OR REPLACE VIEW service_inv
	(service_invoice_id, customer_first_name, customer_last_name, 
	customer_street, customer_city, customer_state, 
	customer_zip, customer_phone, customer_email,
	height, width, length, category,
	service_type, service_price,
	date_of_invoice, price, shipping_price, taxes, 
	misc_price, total,
	empl_first_name, empl_last_name)
AS SELECT
	ser.service_invoice_id, c.customer_first_name, c.customer_last_name, 
	c.customer_street, c.customer_city, c.customer_state, 
	c.customer_zip, c.customer_phone, c.customer_email,
	a.height, a.width, a.length, a.category,
	t.service_type, t.service_price,
	ser.date_of_invoice,t.service_price*NVL(a.height,0)*NVL(a.width,0)*NVL(a.length,0), 
	ser.shipping_price, t.service_price*a.height*a.width*a.length*0.0725, ser.misc_price,
	(t.service_price*a.height*a.width*a.length)+NVL(ser.shipping_price,0)+
	(t.service_price*a.height*a.width*a.length*0.0725)+NVL(ser.misc_price,0),
	e.empl_first_name, e.empl_last_name
FROM 	service_invoices ser  
JOIN 	artworks a
ON	(ser.artwork_id = a.artwork_id)
JOIN 	customers c
ON	(ser.customer_id = c.customer_id)
JOIN 	employees e
ON	(ser.empl_id = e.empl_id)
JOIN 	services t
ON	(ser.service_id = t.service_id);






CREATE OR REPLACE VIEW purchase_agreement_ph
	(purchase_id, vendor_organization, vendor_type, vendor_rep_fname, 
	vendor_rep_lname,vendor_street, vendor_city, 
	vendor_state, vendor_zip, vendor_phone, vendor_fax,
	empl_first_name, empl_last_name,
	artwork_title, short_description, artist_first_name, artist_last_name, 
	date_of_creation, height, width,length, place_of_origin, 
	country_of_origin, category, description,
	art_type, signed, limited, numbered, frame,
	date_of_purchase, purchase_amount, shipping, taxes, misc, total)
AS SELECT
	p.purchase_id, v.vendor_organization, v.vendor_type, v.vendor_rep_fname, 
	v.vendor_rep_lname, v.vendor_street, v.vendor_city, 
	v.vendor_state, v.vendor_zip, v.vendor_phone, v.vendor_fax,
	e.empl_first_name, e.empl_last_name,
	a.artwork_title, a.short_description, a.artist_first_name, a.artist_last_name, 
	a.date_of_creation, a.height, a.width, a.length, a.place_of_origin, 
	a.country_of_origin, a.category, a.description,
	ph.art_type, ph.signed, ph.limited, ph.numbered, ph.frame,
	p.date_of_purchase, p.purchase_amount, p.shipping, p.purchase_amount*0.0725, p.misc, 
	p.purchase_amount+p.purchase_amount*0.0725+NVL(p.misc,0)+NVL(p.shipping,0)	
FROM 	purchases p  
JOIN 	vendors v
ON	(p.vendor_id = v.vendor_id)
JOIN 	employees e
ON	(p.manager_id = e.manager_id)
JOIN 	artworks a
ON	(p.artwork_id = a.artwork_id)
JOIN 	photograph ph
ON	(p.artwork_id = ph.artwork_id);







CREATE OR REPLACE VIEW purchase_agreement_pa
	(purchase_id, vendor_organization, vendor_type, vendor_rep_fname, 
	vendor_rep_lname,vendor_street, vendor_city, 
	vendor_state, vendor_zip, vendor_phone, vendor_fax,
	empl_first_name, empl_last_name,
	artwork_title, short_description, artist_first_name, artist_last_name, 
	date_of_creation, height, width,length, place_of_origin, 
	country_of_origin, category, description,
	media, style, frame,
	date_of_purchase, purchase_amount, shipping, taxes, misc, total)
AS SELECT
	p.purchase_id, v.vendor_organization, v.vendor_type, v.vendor_rep_fname, 
	v.vendor_rep_lname, v.vendor_street, v.vendor_city, 
	v.vendor_state, v.vendor_zip, v.vendor_phone, v.vendor_fax,
	e.empl_first_name, e.empl_last_name,
	a.artwork_title, a.short_description, a.artist_first_name, a.artist_last_name, 
	a.date_of_creation, a.height, a.width, a.length, a.place_of_origin, 
	a.country_of_origin, a.category, a.description,
	pa.media, pa.style, pa.frame,
	p.date_of_purchase, p.purchase_amount, p.shipping, p.purchase_amount*0.0725, p.misc, 
	p.purchase_amount+p.purchase_amount*0.0725+NVL(p.misc,0)+NVL(p.shipping,0)	
FROM 	purchases p  
JOIN 	vendors v
ON	(p.vendor_id = v.vendor_id)
JOIN 	employees e
ON	(p.manager_id = e.manager_id)
JOIN 	artworks a
ON	(p.artwork_id = a.artwork_id)
JOIN 	painting pa
ON	(p.artwork_id = pa.artwork_id);






CREATE OR REPLACE VIEW purchase_agreement_sculp
	(purchase_id, vendor_organization, vendor_type, vendor_rep_fname, 
	vendor_rep_lname,vendor_street, vendor_city, 
	vendor_state, vendor_zip, vendor_phone, vendor_fax,
	empl_first_name, empl_last_name,
	artwork_title, short_description, artist_first_name, artist_last_name, 
	date_of_creation, height, width,length, place_of_origin, 
	country_of_origin, category, description,
	sculpture_type, weight, material, base,
	date_of_purchase, purchase_amount, shipping, taxes, misc, total)
AS SELECT
	p.purchase_id, v.vendor_organization, v.vendor_type, v.vendor_rep_fname, 
	v.vendor_rep_lname, v.vendor_street, v.vendor_city, 
	v.vendor_state, v.vendor_zip, v.vendor_phone, v.vendor_fax,
	e.empl_first_name, e.empl_last_name,
	a.artwork_title, a.short_description, a.artist_first_name, a.artist_last_name, 
	a.date_of_creation, a.height, a.width, a.length, a.place_of_origin, 
	a.country_of_origin, a.category, a.description,
	sculp.sculpture_type, sculp.weight, sculp.material, sculp.base,
	p.date_of_purchase, p.purchase_amount, p.shipping, p.purchase_amount*0.0725, p.misc, 
	p.purchase_amount+p.purchase_amount*0.0725+NVL(p.misc,0)+NVL(p.shipping,0)	
FROM 	purchases p  
JOIN 	vendors v
ON	(p.vendor_id = v.vendor_id)
JOIN 	employees e
ON	(p.manager_id = e.manager_id)
JOIN 	artworks a
ON	(p.artwork_id = a.artwork_id)
JOIN 	sculpture sculp
ON	(p.artwork_id = sculp.artwork_id);





CREATE OR REPLACE VIEW consignment_agreement_sculp
	(consignment_id, vendor_organization, vendor_type, vendor_rep_fname, 
	vendor_rep_lname,vendor_street, vendor_city, 
	vendor_state, vendor_zip, vendor_phone, vendor_fax,
	empl_first_name, empl_last_name,
	artwork_title, short_description, artist_first_name, artist_last_name, 
	date_of_creation, height, width,length, place_of_origin, 
	country_of_origin, category, description,suggested_price, min_selling_price,
	sculpture_type, weight, material, base,
	date_of_consignment, date_of_start, date_of_end, 
	commission_pct, sales_agent_pct)
AS SELECT
	c.consignment_id, v.vendor_organization, v.vendor_type, v.vendor_rep_fname, 
	v.vendor_rep_lname, v.vendor_street, v.vendor_city, 
	v.vendor_state, v.vendor_zip, v.vendor_phone, v.vendor_fax,
	e.empl_first_name, e.empl_last_name,
	a.artwork_title, a.short_description, a.artist_first_name, a.artist_last_name, 
	a.date_of_creation, a.height, a.width, a.length, a.place_of_origin, 
	a.country_of_origin, a.category, a.description, a.suggested_price, a.min_selling_price,
	sculp.sculpture_type, sculp.weight, sculp.material, sculp.base,
	c.date_of_consignment, c.date_of_start, c.date_of_end, c.commission_pct, c.sales_agent_pct	
FROM 	consignments c  
JOIN 	vendors v
ON	(c.vendor_id = v.vendor_id)
JOIN 	employees e
ON	(c.manager_id = e.manager_id)
JOIN 	artworks a
ON	(c.artwork_id = a.artwork_id)
JOIN 	sculpture sculp
ON	(c.artwork_id = sculp.artwork_id);







CREATE OR REPLACE VIEW consignment_agreement_pa
	(consignment_id, vendor_organization, vendor_type, vendor_rep_fname, 
	vendor_rep_lname,vendor_street, vendor_city, 
	vendor_state, vendor_zip, vendor_phone, vendor_fax,
	empl_first_name, empl_last_name,
	artwork_title, short_description, artist_first_name, artist_last_name, 
	date_of_creation, height, width,length, place_of_origin, 
	country_of_origin, category, description,suggested_price, min_selling_price,
	media, style, frame,
	date_of_consignment, date_of_start, date_of_end, 
	commission_pct, sales_agent_pct)
AS SELECT
	c.consignment_id, v.vendor_organization, v.vendor_type, v.vendor_rep_fname, 
	v.vendor_rep_lname, v.vendor_street, v.vendor_city, 
	v.vendor_state, v.vendor_zip, v.vendor_phone, v.vendor_fax,
	e.empl_first_name, e.empl_last_name,
	a.artwork_title, a.short_description, a.artist_first_name, a.artist_last_name, 
	a.date_of_creation, a.height, a.width, a.length, a.place_of_origin, 
	a.country_of_origin, a.category, a.description, a.suggested_price, a.min_selling_price,
	pa.media, pa.style, pa.frame,
	c.date_of_consignment, c.date_of_start, c.date_of_end, c.commission_pct, c.sales_agent_pct	
FROM 	consignments c  
JOIN 	vendors v
ON	(c.vendor_id = v.vendor_id)
JOIN 	employees e
ON	(c.manager_id = e.manager_id)
JOIN 	artworks a
ON	(c.artwork_id = a.artwork_id)
JOIN 	painting pa
ON	(c.artwork_id = pa.artwork_id);






CREATE OR REPLACE VIEW consignment_agreement_ph
	(consignment_id, vendor_organization, vendor_type, vendor_rep_fname, 
	vendor_rep_lname,vendor_street, vendor_city, 
	vendor_state, vendor_zip, vendor_phone, vendor_fax,
	empl_first_name, empl_last_name,
	artwork_title, short_description, artist_first_name, artist_last_name, 
	date_of_creation, height, width,length, place_of_origin, 
	country_of_origin, category, description,suggested_price, min_selling_price,
	art_type, signed, limited, numbered, frame,
	date_of_consignment, date_of_start, date_of_end, 
	commission_pct, sales_agent_pct)
AS SELECT
	c.consignment_id, v.vendor_organization, v.vendor_type, v.vendor_rep_fname, 
	v.vendor_rep_lname, v.vendor_street, v.vendor_city, 
	v.vendor_state, v.vendor_zip, v.vendor_phone, v.vendor_fax,
	e.empl_first_name, e.empl_last_name,
	a.artwork_title, a.short_description, a.artist_first_name, a.artist_last_name, 
	a.date_of_creation, a.height, a.width, a.length, a.place_of_origin, 
	a.country_of_origin, a.category, a.description, a.suggested_price, a.min_selling_price,
	ph.art_type, ph.signed, ph.limited, ph.numbered, ph.frame,
	c.date_of_consignment, c.date_of_start, c.date_of_end, c.commission_pct, c.sales_agent_pct	
FROM 	consignments c  
JOIN 	vendors v
ON	(c.vendor_id = v.vendor_id)
JOIN 	employees e
ON	(c.manager_id = e.manager_id)
JOIN 	artworks a
ON	(c.artwork_id = a.artwork_id)
JOIN 	photograph ph
ON	(c.artwork_id = ph.artwork_id);





















CREATE 		VIEW query_a
AS
SELECT  	artwork_id, artwork_title, status
FROM 		artworks
WHERE 		status= 'For Sale';






CREATE		VIEW query_c
AS
SELECT 		a.artwork_id, a.artwork_title, a.short_description, c.date_of_start, c.date_of_end, 
		v.vendor_rep_fname, v.vendor_rep_lname, v.vendor_organization
FROM 		artworks a 
JOIN 		consignments c
ON 		(a.artwork_id = c.artwork_id)
JOIN 		vendors v
ON 		(v.vendor_id = c.vendor_id)
WHERE 		a.status = 'For Sale';



CREATE		VIEW query_d
AS
SELECT 		a.artwork_id, a.artwork_title, a.short_description, c.date_of_start, c.date_of_end, 
		v.vendor_rep_fname, v.vendor_rep_lname, v.vendor_organization
FROM 		artworks a 
JOIN 		consignments c
ON 		(a.artwork_id = c.artwork_id)
JOIN 		vendors v
ON 		(v.vendor_id = c.vendor_id)
WHERE		180 < (SYSDATE-c.date_of_end) and a.status = 'Returned';







CREATE 		VIEW query_f
AS SELECT	t.service_type, SUM(t.service_price*a.height*a.width*a.length) revenue
FROM 		services t
JOIN 		service_invoices ser
ON		(ser.service_id = t.service_id)
JOIN 		artworks a
ON		(ser.artwork_id = a.artwork_id)
GROUP BY 	t.service_type;




CREATE 		VIEW query_g_a
AS SELECT	e.empl_first_name, e.empl_last_name,
		SUM(s.sales_price*e.commission) AS "Total Commission"
FROM 		employees e 
JOIN 		sales_invoices s
ON		(s.empl_id = e.empl_id)
GROUP BY 	e.empl_first_name, e.empl_last_name
HAVING		SUM(s.sales_price) = 
(SELECT 	MAX(SUM(s.sales_price))
FROM 		employees e
JOIN		sales_invoices s
ON		(s.empl_id = e.empl_id)
GROUP BY	e.empl_first_name, e.empl_last_name);




CREATE 		VIEW query_g_b
AS SELECT	e.empl_first_name, e.empl_last_name,
		COUNT(s.empl_id) AS "Artworks Sold"
FROM 		employees e 
JOIN 		sales_invoices s
ON		(s.empl_id = e.empl_id)
GROUP BY 	e.empl_first_name, e.empl_last_name
HAVING		COUNT(s.sales_price) = (SELECT MAX(COUNT(s.sales_price))
FROM 		employees e
JOIN		sales_invoices s
ON		(s.empl_id = e.empl_id)
GROUP BY	e.empl_first_name, e.empl_last_name);





CREATE 		VIEW query_h
AS SELECT 	c.customer_first_name, c.customer_last_name, c.customer_phone
FROM 		customers c 
JOIN 		sales_invoices s
ON 		(c.customer_id = s.customer_id)
GROUP BY	c.customer_first_name, c.customer_last_name,c.customer_phone;




CREATE VIEW 	query_i
AS SELECT 	c.customer_first_name, c.customer_last_name, p.artwork_type
FROM 		customers c 
RIGHT JOIN 	preferences p
ON 		(c.customer_id = p.customer_id)
LEFT JOIN 	sales_invoices s
ON 		(c.customer_id = s.customer_id)
WHERE		s.customer_id IS NULL
GROUP BY	c.customer_first_name, c.customer_last_name, p.artwork_type;


CREATE VIEW 	query_j
AS SELECT 	c.customer_first_name, c.customer_last_name
FROM 		customers c 
JOIN 		sales_invoices s
ON 		(c.customer_id = s.customer_id)
JOIN 		service_invoices i
ON 		(i.customer_id = c.customer_id)
WHERE		s.customer_id IS NOT NULL AND
		i.customer_id IS NOT NULL
GROUP BY	c.customer_last_name, c.customer_first_name;











