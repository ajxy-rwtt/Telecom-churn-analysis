# checking for the international plan by state
SELECT state,
       international_plan,
       COUNT(*) AS total,
       SUM(COUNT(*)) OVER (PARTITION BY international_plan) AS plan_total
FROM projects.telecom_churn_final_data
GROUP BY state, international_plan;


# categorising users by their account length
SELECT
  CASE 
    WHEN account_length <= 30 THEN '1-30(New)'
    WHEN account_length <= 100 THEN '31-100(long_term_customer)'
    ELSE '100+ (loyal)'
  END AS tenure_group,
  COUNT(account_length) as churn_analysis,
  AVG(total_day_minutes) AS avg_total_days_mins
FROM telecom_churn_final_data
GROUP BY tenure_group;


# customer complaints
SELECT 
    MIN(customer_service_calls),
    MAX(customer_service_calls),
    AVG(customer_service_calls)
FROM telecom_churn_final_data;

SELECT 
    state,
    CASE 
        WHEN customer_service_calls <= 1 THEN 'Low Complaints'
        WHEN customer_service_calls <= 3 THEN 'Medium Complaints'
        ELSE 'High Complaints'
    END AS complaint_group,
    COUNT(*) AS customer_count
FROM telecom_churn_final_data
GROUP BY state, complaint_group;


# churn analysis(who is more likely to churn )
SELECT 	
    churn,
    COUNT(*) AS total
FROM telecom_churn_final_data
GROUP BY churn;

SELECT 
    row_id,
    state,
    churn,
    COUNT(*) OVER (PARTITION BY state, churn) AS count_per_group
FROM telecom_churn_final_data;


# risk analysis
SELECT row_id,state,account_length,
    CASE 
        WHEN customer_service_calls >= 4 AND total_intl_charge > 3 THEN 'High Risk'
        WHEN customer_service_calls >= 3 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS churn_risk
FROM telecom_churn_final_data;


# creating new variable 
SELECT*,
    total_day_minutes + total_eve_minutes + total_night_minutes AS total_usage,
    total_day_charge + total_eve_charge + total_night_charge + total_intl_charge AS total_bill
FROM telecom_churn_final_data;


# avg revenue overall
SELECT 
    churn,
    AVG(total_day_charge + total_eve_charge + total_night_charge + total_intl_charge) AS avg_revenue
FROM telecom_churn_final_data
GROUP BY churn;