-- PATIENT PLAYGROUND
SELECT  v.bh_visit_id, v.patient_id, bp.name AS patient_names, v.bh_visitdate AS visit_date
FROM bh_visit v
JOIN c_bpartner bp  -- List of patient names who have visited 'Client' clinic within x duration
    ON v.patient_id = bp.c_bpartner_id
WHERE v.bh_visitdate >= '2023-10-01 00:00:00.000000'::timestamp AND v.bh_visitdate <= '2023-10-31 00:00:00.000000'::timestamp;

-- TREND OF DAILY VISITS ON GRAFANA
SELECT  COUNT(v.patient_id) Daily_visits, TO_CHAR(v.bh_visitdate, 'YYYY-MM-DD') AS Date
FROM bh_visit v
JOIN c_bpartner bp  -- List of patient names who have visited 'Client' clinic within x duration
    ON v.patient_id = bp.c_bpartner_id
WHERE v.bh_visitdate >= '2023-10-01 00:00:00.000000'::timestamp AND v.bh_visitdate <= '2023-10-31 00:00:00.000000'::timestamp
GROUP BY Date
ORDER BY Date;

-- OUTSTANDING BALANCES PLAYGROUND
SELECT bp.c_bpartner_id, bp.name, bp.so_creditused, bp.updated
FROM c_bpartner bp      -- All patients with outstanding balances
WHERE bp.so_creditused > 100 AND (bp.updated >= '2023-10-01 00:00:00.000000'::timestamp AND bp.updated <= '2024-01-01 00:00:00.000000'::timestamp)
ORDER BY bp.so_creditused DESC;

-- VENDOR PLAYGROUND
SELECT DISTINCT ON (O.c_bpartner_id) bp.name AS vendor_names, O.issotrx, o.dateacct AS Date_Purchased
FROM c_order O
JOIN c_bpartner bp  --List of unique vendors and date purchased within x duration
    ON O.c_bpartner_id = bp.c_bpartner_id
WHERE bp.isvendor = 'Y'AND (o.dateacct >= '2023-10-01 00:00:00.000000'::timestamp AND O.dateacct <= '2023-10-31 00:00:00.000000'::timestamp);

-- DIAGNOSIS PLAYGROUND
SELECT v.bh_visit_id, v.patient_id, v.bh_visitdate AS visit_date, bp.name AS patient_name, e.bh_encounter_id, bed.bh_coded_diagnosis_id, bcd.bh_cielname AS Diagnosis
FROM bh_visit v
JOIN c_bpartner bp
    ON v.patient_id = bp.c_bpartner_id
JOIN bh_encounter e                             -- Get all patients with at least one Diagnosis within x duration
    ON v.bh_visit_id = e.bh_visit_id
JOIN bh_encounter_diagnosis bed
    ON e.bh_encounter_id = bed.bh_encounter_id
JOIN bh_coded_diagnosis bcd
    ON bed.bh_coded_diagnosis_id = bcd.bh_coded_diagnosis_id
WHERE bed.bh_coded_diagnosis_id IS NOT NULL AND (v.bh_visitdate >= '2023-10-01 00:00:00.000000'::timestamp AND v.bh_visitdate <= '2024-01-01 00:00:00.000000'::timestamp);