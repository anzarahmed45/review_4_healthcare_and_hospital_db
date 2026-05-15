CREATE TABLE patients (
    patient_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    gender VARCHAR(10),
    dob DATE,
    phone VARCHAR(15) UNIQUE,
    insurance_id VARCHAR(50) UNIQUE
);

CREATE TABLE doctors (
    doctor_id SERIAL PRIMARY KEY,
    doctor_name VARCHAR(100),
    specialization VARCHAR(100),
    department VARCHAR(100),
    fee NUMERIC(10,2)
);

CREATE TABLE appointments (
    appointment_id SERIAL PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date TIMESTAMP,
    CONSTRAINT fk_patient
    FOREIGN KEY (patient_id)
    REFERENCES patients(patient_id),
    CONSTRAINT fk_doctor
    FOREIGN KEY (doctor_id)
    REFERENCES doctors(doctor_id)
);

CREATE TABLE medicines (
    medicine_id SERIAL PRIMARY KEY,
    medicine_name VARCHAR(100),
    stock INT CHECK(stock >= 0),
    price NUMERIC(10,2)
);

CREATE TABLE prescriptions (
    prescription_id SERIAL,
    patient_id INT,
    medicine_id INT,
    quantity INT,
    PRIMARY KEY (prescription_id, medicine_id),
    FOREIGN KEY (patient_id)
    REFERENCES patients(patient_id),
    FOREIGN KEY (medicine_id)
    REFERENCES medicines(medicine_id)
);

CREATE TABLE billing (
    bill_id SERIAL PRIMARY KEY,
    patient_id INT,
    total_amount NUMERIC(10,2),
    payment_status VARCHAR(20),
    FOREIGN KEY (patient_id)
    REFERENCES patients(patient_id)
);

INSERT INTO patients
(name, gender, dob, phone, insurance_id)
VALUES
('Ahamed', 'Male', '2002-06-15', '9876543210', 'INS101'),
('Shiva', 'Male', '1999-08-10', '9876501234', 'INS102');


INSERT INTO doctors
(doctor_name, specialization, department, fee)
VALUES
('Dr Gouri', 'Cardiologist', 'Cardiology', 1500),
('Dr Priya', 'Neurologist', 'Neurology', 2000);


INSERT INTO medicines
(medicine_name, stock, price)
VALUES
('Paracetamol', 100, 5.50),
('Strepsils', 50, 12.75);


INSERT INTO appointments
(patient_id, doctor_id, appointment_date)
VALUES
(1, 1, '2026-06-01 10:00:00');


INSERT INTO prescriptions
(patient_id, medicine_id, quantity)
VALUES
(1, 1, 5);


INSERT INTO billing
(patient_id, total_amount, payment_status)
VALUES
(1, 2500, 'Pending');


SELECT
    p.name,
    d.doctor_name,
    a.appointment_date
FROM appointments a
JOIN patients p
ON a.patient_id = p.patient_id
JOIN doctors d
ON a.doctor_id = d.doctor_id;


SELECT
    p.name,
    a.appointment_id
FROM patients p
FULL OUTER JOIN appointments a
ON p.patient_id = a.patient_id;


SELECT
    doctor_id,
    COUNT(*) AS total_patients
FROM appointments
GROUP BY doctor_id;


CREATE OR REPLACE FUNCTION bmi(weight NUMERIC, height NUMERIC)
RETURNS NUMERIC AS
$$
BEGIN
    RETURN weight / (height * height);
END;
$$ LANGUAGE plpgsql;

SELECT bmi(70, 1.75);


CREATE OR REPLACE FUNCTION reduce_stock()
RETURNS TRIGGER AS
$$
BEGIN
    UPDATE medicines
    SET stock = stock - NEW.quantity
    WHERE medicine_id = NEW.medicine_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER medicine_trigger
AFTER INSERT ON prescriptions
FOR EACH ROW
EXECUTE FUNCTION reduce_stock();


CREATE VIEW doctor_schedule AS
SELECT
    d.doctor_name,
    p.name,
    a.appointment_date
FROM appointments a
JOIN doctors d
ON a.doctor_id = d.doctor_id
JOIN patients p
ON a.patient_id = p.patient_id;

SELECT * FROM doctor_schedule;


CREATE INDEX patient_name_index
ON patients(name);


EXPLAIN ANALYZE
SELECT *
FROM patients
WHERE name = 'Ahamed';


BEGIN;

UPDATE medicines
SET stock = stock - 5
WHERE medicine_id = 1;
UPDATE billing
SET payment_status = 'Paid'
WHERE bill_id = 1;

COMMIT;

ROLLBACK;

BEGIN;

UPDATE medicines
SET stock = stock - 5
WHERE medicine_id = 1;

ROLLBACK;