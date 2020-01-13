DROP TABLE SkillsCategory_Through CASCADE ;
DROP TABLE Skills_Through CASCADE ;
DROP TABLE Job_Skills_Through CASCADE ;
DROP TABLE Application_Through CASCADE ;
DROP TABLE Jobs CASCADE ;
DROP TABLE Freelancers CASCADE ;
DROP TABLE Skills CASCADE ;
DROP TABLE SkillsCategory CASCADE ;
DROP TABLE ServiceCategories CASCADE ;
DROP TABLE Employers CASCADE ;
DROP TABLE Users CASCADE ;

CREATE TYPE USER_TYPE AS ENUM ('employer', 'freelancer');

CREATE TABLE ServiceCategories(
    id SERIAL PRIMARY KEY,
    category VARCHAR(40)
);

CREATE TABLE SkillsCategory(
    id serial PRIMARY KEY,
    serviceCategory integer REFERENCES ServiceCategories(id),
    skillCategory varchar(50)
);

CREATE TABLE Skills(
    id serial PRIMARY KEY,
    skillCategory integer REFERENCES SkillsCategory(id),
    skill varchar(50) UNIQUE
);

CREATE TYPE EXPERIENCE as ENUM (
    'Begginer',
    'Intermediate',
    'Expert'
);

CREATE TABLE Users(
    id SERIAL PRIMARY KEY,
    type USER_TYPE,
    mail VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(87) NOT NULL,
    token VARCHAR(36) NOT NULL
);

CREATE TABLE  Employers(
    id serial primary key,
    uid integer REFERENCES Users(id) ON DELETE CASCADE,
    phone varchar(12),
    lastName varchar(50),
    firstName varchar(50),
    rating float DEFAULT 0,
    nrrating integer DEFAULT 0,
    jobsPosted integer DEFAULT 0,
    moneySpent float DEFAULT 0
);

CREATE TABLE Freelancers(
    id serial primary key,
    uid integer REFERENCES Users(id) ON DELETE CASCADE,
    phone varchar(12),
    lastName varchar(50),
    firstName varchar(50),
    rating float DEFAULT 0,
    nrrating integer DEFAULT 0,
    description varchar(200),
    photo varchar(100),
    mainSkill integer REFERENCES ServiceCategories(id),
    experience EXPERIENCE,
    balance float default 0
    -- SkillsCategory
    -- Skills
);


-- Used for many-to-many relation between freelancers and skillsCategory.
-- A freelancer can have many skill categories and many freelancers can have the same skill category.
CREATE TABLE SkillsCategory_Through(
    freelancer_id integer REFERENCES Freelancers(id),
    skillCategory_id integer REFERENCES SkillsCategory(id)
);

-- Used for many-to-many relation between freelancers and skills.
-- A freelancer can have many skills and many freelancers can have the same skill.
CREATE TABLE Skills_Through(
    freelancer_id integer REFERENCES Freelancers(id),
    skill_id integer REFERENCES Skills(id)
);

CREATE TYPE JOB_STATUS AS ENUM(
    'OPEN',
    'WIP',
    'DONE'
);

CREATE TABLE Jobs(
    id serial PRIMARY KEY,
    employer integer REFERENCES Users(id),
    posted timestamp NOT NULL DEFAULT current_timestamp,
    status JOB_STATUS NOT NULL DEFAULT 'OPEN',
    title varchar(50) NOT NULL,
    serviceCatergory integer REFERENCES ServiceCategories(id),
    skillCatergory integer REFERENCES SkillsCategory(id),
    explevel EXPERIENCE NOT NULL,
    wage integer CHECK ( wage > 0 ),
    places integer CHECK (places >= 0),
    description varchar(500)
    -- Required Skills
    -- Applicants
);

-- Used for many-to-many relation between jobs and necessary skills.
-- A job may require many skills, while multiple job may require the same skill
CREATE TABLE Job_Skills_Through(
    job_id integer REFERENCES Jobs(id),
    skill_id integer REFERENCES Skills(id)
);

CREATE TYPE APPLICATION_STATUS AS ENUM (
    'Waiting',
    'Accepted'
);

-- Used for many-to-many relation between jobs and applicans
-- A job may have multiple applicants, while a freelancer can apply to multiple jobs.
CREATE TABLE Application_Through(
    job_id integer REFERENCES Jobs(id),
    freelanger_id integer REFERENCES Freelancers(id),
    status APPLICATION_STATUS
);

INSERT INTO ServiceCategories(category) VALUES ('Accounting & Consulting');
INSERT INTO ServiceCategories(category) VALUES ('Data Science & Analytics');
INSERT INTO ServiceCategories(category) VALUES ('Design & Creative');
INSERT INTO ServiceCategories(category) VALUES ('Engineering & Architecture');
INSERT INTO ServiceCategories(category) VALUES ('IT & Networking');
INSERT INTO ServiceCategories(category) VALUES ('Legal');
INSERT INTO ServiceCategories(category) VALUES ('Sales & Marketing');
INSERT INTO ServiceCategories(category) VALUES ('Translation');
INSERT INTO ServiceCategories(category) VALUES ('Web, Mobile & Software Dev');
INSERT INTO ServiceCategories(category) VALUES ('Writing');

INSERT INTO SkillsCategory(serviceCategory, skillCategory) VALUES (1, 'Accounting');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) VALUES (1, 'Human Resources');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) VALUES (1, 'Financial Planing');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) VALUES (1, 'Management Consulting');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) VALUES (1, 'Other');

INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (2, 'A/B Testing');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (2, 'Data Mining');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (2, 'Machine Learning');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (2, 'Data Extraction');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (2, 'Data Visualization');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (2, 'Other');

INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (3, 'Animation');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (3, 'Audio Production');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (3, 'Photography');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (3, 'Art & Illustration');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (3, 'Brand Identity & Strategy');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (3, 'Graphics & Design');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (3, 'Other');

INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (4, '3D Modeling & CAD');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (4, 'Interior Design');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (4, 'Architecture');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (4, 'Electrical Engineering');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (4, 'Other');

INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (5, 'Database Administration');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (5, 'Information Security');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (5, 'Network & System Administration');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (5, 'Other');

INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (6, 'Contract Law');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (6, 'Criminal Law');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (6, 'Corporate Law');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (6, 'Other');

INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (7, 'Public Relations');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (7, 'SEO');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (7, 'Social Media');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (7, 'General Marketing');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (7, 'Other');

INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (8, 'General Translation');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (8, 'Legal Translation');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (8, 'Technical Translation');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (8, 'Medical Translation');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (8, 'Other');

INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (9, 'Desktop Development');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (9, 'Game Development');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (9, 'Ecommerce Development');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (9, 'Mobile Development');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (9, 'Web Development');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (9, 'Web & Mobile Design');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (9, 'Other');

INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (10, 'Academic Writing & Research');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (10, 'Copywriting');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (10, 'Technical Writing');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (10, 'Creative Writing');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (10, 'Resumes & Cover Letters');
INSERT INTO SkillsCategory(serviceCategory, skillCategory) values (10, 'Other');


------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE create_user(IN utype USER_TYPE, IN umail varchar, IN upassword varchar, IN utoken varchar)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Users(type, mail, password, token) VALUES (utype, umail, upassword, utoken);
END;
$$;

CREATE OR REPLACE FUNCTION create_user_profile() RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.type = 'employer' THEN
        INSERT INTO Employers(uid) VALUES (NEW.id);
    ELSIF NEW.type = 'freelancer' THEN
        INSERT INTO Freelancers(uid) VALUES (NEW.id);
    END IF;

    RETURN NULL;
END;
$$;

CREATE TRIGGER create_user_profile_trigger
AFTER INSERT ON Users
FOR EACH ROW
EXECUTE FUNCTION create_user_profile();

CREATE OR REPLACE FUNCTION login_user(IN umail varchar, OUT hash varchar, OUT atoken varchar, OUT utype USER_TYPE)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT u.password, u.token, u.type INTO hash, atoken, utype FROM Users u WHERE u.mail = umail;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
END;
$$;

CREATE OR REPLACE FUNCTION authenticate_user(IN atoken varchar, OUT uid integer, OUT utype USER_TYPE)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT id, type INTO uid, utype FROM Users WHERE token = atoken;
end;
$$;

CREATE TYPE employer_profile AS (
    phone varchar,
    lastName varchar,
    firstName varchar,
    rating float,
    jobsPosted integer,
    moneySpent float
);

CREATE OR REPLACE FUNCTION get_employer_profile(IN euid integer) RETURNS employer_profile
LANGUAGE plpgsql
AS $$
DECLARE
    emp_profile employer_profile;
BEGIN
    SELECT phone, lastName, firstName, rating, jobsPosted, moneySpent INTO STRICT emp_profile FROM Employers WHERE uid = euid;
    return emp_profile;
exception when no_data_found then
    raise no_data_found;
END;
$$;


CREATE TYPE freelancer_profile AS (
    phone varchar,
    lastName varchar,
    firstName varchar,
    rating float,
    description varchar,
    photo varchar,
    mainSkill integer,
    balance float
);

CREATE OR REPLACE FUNCTION get_freelancer_profile(IN fuid integer) RETURNS freelancer_profile
LANGUAGE plpgsql
AS $$
DECLARE
    frc_profile freelancer_profile;
BEGIN
    SELECT phone, lastName, firstName, rating, description, photo, mainSkill, balance INTO STRICT frc_profile FROM Freelancers WHERE uid = fuid;
    return frc_profile;
exception when no_data_found then
    raise no_data_found;
END;
$$;


------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION get_service_categories()
RETURNS SETOF ServiceCategories
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT *  FROM ServiceCategories;
end;
$$;

CREATE OR REPLACE FUNCTION get_skill_categories(service_category_id integer)
RETURNS SETOF SkillsCategory
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT *  FROM SkillsCategory where serviceCategory = service_category_id;
end;
$$;

CREATE OR REPLACE FUNCTION get_skills(skill_category_id integer)
RETURNS SETOF Skills
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM Skills where skillCategory = skill_category_id;
end;
$$;

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION get_user_skill_categories(fuid integer)
RETURNS SETOF SkillsCategory
LANGUAGE plpgsql
AS $$
DECLARE
    fid integer;
BEGIN
    SELECT id into fid from Freelancers where Freelancers.uid = fuid;

    RETURN QUERY
    SELECT SkillsCategory.id, SkillsCategory.serviceCategory, SkillsCategory.skillCategory FROM SkillsCategory join SkillsCategory_Through on SkillsCategory.id = SkillsCategory_Through.skillCategory_id
    WHERE SkillsCategory_Through.freelancer_id = fid;
end;
$$;

CREATE OR REPLACE FUNCTION get_user_skills(fuid integer)
RETURNS SETOF Skills
LANGUAGE plpgsql
AS $$
DECLARE
    fid integer;
BEGIN
    SELECT id into fid from Freelancers where Freelancers.uid = fuid;

    RETURN QUERY
    SELECT Skills.id, Skills.skillCategory, Skills.skill FROM Skills join Skills_Through on Skills.id = Skills_Through.skill_id
    WHERE Skills_Through.freelancer_id = fid;
end;
$$;

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

create or replace function set_user_skill_categories(fuid integer, categories integer[])
returns void
language plpgsql
as
$$
DECLARE
    fid integer;
    categ integer;
BEGIN
    SELECT id into fid from Freelancers where Freelancers.uid = fuid;
    delete from SkillsCategory_Through where freelancer_id = fid;

    foreach categ in array categories
    loop
        INSERT INTO SkillsCategory_Through(freelancer_id, skillCategory_id)
        VALUES (fid, categ);
    end loop;
end;
$$;


create or replace function set_user_skills(fuid integer, categories integer[], newskill varchar[])
returns void
language plpgsql
as
$$
DECLARE
    fid integer;
    idx integer;
    nwskill varchar;
    newskill_id integer;
BEGIN
    SELECT id into fid from Freelancers where Freelancers.uid = fuid;
    delete from Skills_Through where freelancer_id = fid;

    idx := 1;

    foreach nwskill in array newskill
    loop
        BEGIN
            INSERT INTO Skills(skillCategory, skill) VALUES (categories[idx], nwskill) RETURNING id INTO newskill_id;
            INSERT INTO Skills_Through(freelancer_id, skill_id) VALUES (fid, newskill_id);
        EXCEPTION WHEN unique_violation THEN
            SELECT id INTO newskill_id from Skills WHERE skillCategory = categories[idx] and skill = nwskill;
            INSERT INTO Skills_Through(freelancer_id, skill_id) VALUES (fid, newskill_id);
        END;
        idx := idx + 1;
    end loop;
end;
$$;

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION edit_employer_profile(IN euid integer, IN lname varchar, IN fname varchar, IN nphone varchar)
RETURNS employer_profile
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Employers SET
        lastName = COALESCE(lname, lastName),
        firstName = COALESCE(fname, firstName),
        phone = COALESCE(nphone, phone)
    WHERE uid = euid;

    RETURN get_employer_profile(euid);
END;
$$;

CREATE OR REPLACE FUNCTION edit_freelancer_profile(IN fuid integer, IN lname varchar, IN fname varchar, IN nphone varchar,
                                                    IN descr varchar, IN nphoto varchar, IN mskill integer, IN exp EXPERIENCE)
RETURNS freelancer_profile
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Freelancers SET
        lastName = COALESCE(lname, lastName),
        firstName = COALESCE(fname, firstName),
        phone = COALESCE(nphone, phone),
        description = COALESCE(descr, description),
        photo = COALESCE(nphoto, photo),
        mainSkill = COALESCE(mskill, mainSkill),
        experience = COALESCE(exp, experience)
    WHERE uid = fuid;

    RETURN get_freelancer_profile(fuid);
END;
$$;


------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

CREATE TYPE skill_record AS (
    categ integer,
    skill varchar
);

CREATE OR REPLACE FUNCTION create_job(IN euid integer, IN jtitle varchar, IN jservice integer, IN jcateg integer,
                                       IN jexp EXPERIENCE, IN jwage float, IN jplaces integer, IN jdescription varchar,
                                       IN jskills skill_record[])
RETURNS SETOF Jobs
LANGUAGE plpgsql
AS $$
DECLARE
    eid integer;
    jscid integer;
    jskill skill_record;
    jskillid integer;
    job Jobs % rowtype;
BEGIN
    raise warning '%', jskills;

    SELECT id into eid from Employers where Employers.uid = euid;

    INSERT  INTO Jobs(employer, title, serviceCatergory, skillCatergory, explevel, wage, places, description)
            VALUES (euid, jtitle, jservice, jcateg, jexp, jwage, jplaces, jdescription)
            RETURNING * into job;

    jscid := 1;
    FOREACH jskill IN ARRAY jskills
    LOOP
        BEGIN
            INSERT INTO Skills(skillCategory, skill) VALUES (jskill.categ, jskill.skill) RETURNING id into jskillid;
            INSERT INTO Job_Skills_Through(job_id, skill_id) VALUES (job.id, jskillid);
        EXCEPTION WHEN unique_violation THEN
            SELECT id into jskillid from Skills where Skills.skillCategory = jskill.categ and Skills.skill = jskill.skill;
            INSERT INTO Job_Skills_Through(job_id, skill_id) VALUES (job.id, jskillid);
        END;
    END LOOP;

    update employers set jobsPosted = jobsPosted + 1 where id = eid;

    return next job;
END;
$$;

CREATE TYPE job_details AS (
    id integer,
    euid integer,
    title varchar,
    service integer,
    categ integer,
    wage float,
    postTime timestamp,
    description varchar,
    experience varchar,
    places integer,
    nrOfCandidates integer,
    employerRating float,
    employerTotalMoneySpent float,
    skills skill_record[]
);

create type wage_range as (
    low float,
    high float
);

create or replace function wage_is_between(wage integer, wage_ranges wage_range[])
returns boolean
language plpgsql
as $$
declare
    wage_range wage_range;
begin
    foreach wage_range in array wage_ranges
    loop
        if wage_range.high is NULL then
            if wage > wage_range.low then
                return true;
            end if;
        else
            if wage between wage_range.low and wage_range.high then
                return true;
            end if;
        end if;
    end loop;

    return false;
end;
$$;

create or replace function job_requires_skills(jid integer, reqskills varchar[])
returns boolean
language plpgsql
as $$
begin
    if reqskills is NULL or array_length(reqskills, 1) = 0 then
        return true;
    end if;

    if (select count(*) from (
        select * from (
            select unnest(reqskills)
            intersect
            select skill
            from skills join job_skills_through jst on Skills.id = jst.skill_id
            where jst.job_id = jid
        ) as intersection
    ) as common_count ) = array_length(reqskills, 1) then
        return true;
    else
        return false;
    end if;
end;
$$;

create or replace function get_jobs(euid integer, qtitle varchar, explvl EXPERIENCE[],
                                    wage_ranges wage_range[], reqskills varchar[],
                                    service integer)
returns setof job_details
    language plpgsql
as
$$
DECLARE
    eid integer;
    erating float;
    emoney float;
    nrCandidates integer;
    job_detail job_details;
    jobs_details job_details[] := '{}';
    job jobs%rowtype;
    jskill skill_record;
BEGIN
    if euid is NULL then
        CREATE TEMP TABLE temp_employers ON COMMIT DROP AS (select id from Users where type = 'employer');
    else
        CREATE TEMP TABLE temp_employers ON COMMIT DROP AS (select euid);
    end if;

    if service is NULL then
        CREATE TEMP TABLE temp_service ON COMMIT DROP AS (select id from servicecategories);
    else
        CREATE TEMP TABLE temp_service ON COMMIT DROP AS (select service);
    end if;

    for job in SELECT * FROM Jobs
    where employer in (SELECT * FROM temp_employers)
        and serviceCatergory in (SELECT * from temp_service)
        and title like '%' || qtitle || '%'
        and explevel in (SELECT unnest(explvl))
        and wage_is_between(wage, wage_ranges) = true
        and job_requires_skills(id, reqskills) = true
        and status = 'OPEN'
    order by posted desc
    loop
        SELECT id, rating, moneyspent INTO eid, erating, emoney FROM Employers WHERE uid = job.employer;

        select count(*) into nrCandidates from application_through where job_id = job.id;

        SELECT job.id, job.employer, job.title, job.serviceCatergory, job.skillCatergory,
               job.wage, job.posted, job.description, job.explevel, job.places,
               nrCandidates, erating, emoney, '{}'
        INTO job_detail;

        for jskill in select s.skillcategory, s.skill from skills s, job_skills_through jst
        where jst.job_id = job.id and jst.skill_id = s.id
        loop
            job_detail.skills := job_detail.skills || jskill;
        end loop;

        jobs_details := jobs_details || job_detail;
    end loop;

    foreach job_detail in array jobs_details
    loop
        return next job_detail;
    end loop;
END;
$$;

create or replace function check_already_applied(jid integer, fid integer)
returns boolean
language plpgsql
as $$
declare
    astatus APPLICATION_STATUS;
begin
    SELECT status into astatus from application_through where job_id = jid and freelanger_id = fid;
    if astatus is NULL then
        return false;
    end if;
    return true;
exception when no_data_found then
    return false;
end;
$$;


create or replace function apply_for_job(jid integer, fuid integer)
returns void
language plpgsql
as $$
declare
    fid integer;
    already boolean;
    utype USER_TYPE;
begin
    select type into utype from users where id = fuid;
    if utype = 'employer' then
        raise invalid_parameter_value;
    end if;

    select id into fid from Freelancers where uid = fuid;
    already := check_already_applied(jid, fid);

    if already = true then
        raise unique_violation;
    end if;

    insert into Application_Through(job_id, freelanger_id, status)
    values (jid, fid, 'Waiting');
end;
$$;

create or replace function get_applicants(jid integer)
returns setof Freelancers
language plpgsql
as $$
begin
    return query
    select id, uid, phone, lastName, firstName, rating, nrrating, description, photo, mainSkill, experience, balance
    from Freelancers f join Application_Through at on f.id = at.freelanger_id
    where at.job_id = jid and at.status = 'Waiting';
end;
$$;

create or replace function select_candidate(jid integer, fid integer)
returns void
language plpgsql
as $$
declare
    placesLeft integer;
begin
    update jobs set places = places - 1 where id = jid and status = 'OPEN' returning places into placesLeft;
    update Application_Through set status = 'Accepted' where job_id = jid and freelanger_id = fid;

    raise notice '%', placesLeft;
    if placesLeft = 0 then
        update jobs set status = 'WIP' where id = jid;
    end if;
end;
$$;


create or replace function get_accepted(jid integer)
returns setof Freelancers
language plpgsql
as $$
begin
    return query
    select id, uid, phone, lastName, firstName, rating, nrrating, description, photo, mainSkill, experience, balance
    from Freelancers f join Application_Through at on f.id = at.freelanger_id
    where at.job_id = jid and at.status = 'Accepted';
end;
$$;

create or replace function finish_job(euid integer, jid integer)
returns void
language plpgsql
as $$
declare
    ok integer;
    jwage float;
begin
    update jobs set status = 'DONE'
    where id = jid
        and status = 'WIP'
        and employer = euid
    returning id, wage into ok, jwage;
    if ok is not NULL then
        update employers set moneySpent = moneySpent + jwage where uid = euid;
        update freelancers set balance = balance + jwage
        where id in (SELECT freelanger_id from application_through where job_id = jid);
        return;
    end if;

    raise integrity_constraint_violation;
end;
$$;

create or replace function get_accepted_jobs(fuid integer)
returns setof job_details
    language plpgsql
as
$$
DECLARE
    eid integer;
    erating float;
    emoney float;
    nrCandidates integer;
    job_detail job_details;
    jobs_details job_details[] := '{}';
    job jobs%rowtype;
    jskill skill_record;
BEGIN
    for job in SELECT * FROM Jobs
    where fuid in (SELECT uid from get_accepted(jobs.id))
        and (status = 'OPEN' or status = 'WIP')
    order by posted desc
    loop
        SELECT id, rating, moneyspent INTO eid, erating, emoney FROM Employers WHERE uid = job.employer;

        select count(*) into nrCandidates from application_through where job_id = job.id;

        SELECT job.id, job.employer, job.title, job.serviceCatergory, job.skillCatergory,
               job.wage, job.posted, job.description, job.explevel, job.places,
               nrCandidates, erating, emoney, '{}'
        INTO job_detail;

        for jskill in select s.skillcategory, s.skill from skills s, job_skills_through jst
        where jst.job_id = job.id and jst.skill_id = s.id
        loop
            job_detail.skills := job_detail.skills || jskill;
        end loop;

        jobs_details := jobs_details || job_detail;
    end loop;

    foreach job_detail in array jobs_details
    loop
        return next job_detail;
    end loop;
END;
$$;

create or replace function get_history_jobs(fuid integer)
returns setof job_details
    language plpgsql
as
$$
DECLARE
    eid integer;
    erating float;
    emoney float;
    nrCandidates integer;
    job_detail job_details;
    jobs_details job_details[] := '{}';
    job jobs%rowtype;
    jskill skill_record;
BEGIN
    for job in SELECT * FROM Jobs
    where (fuid in (SELECT uid from get_accepted(jobs.id)) or employer = fuid)
        and status = 'DONE'
    order by posted desc
    loop
        SELECT id, rating, moneyspent INTO eid, erating, emoney FROM Employers WHERE uid = job.employer;

        select count(*) into nrCandidates from application_through where job_id = job.id;

        SELECT job.id, job.employer, job.title, job.serviceCatergory, job.skillCatergory,
               job.wage, job.posted, job.description, job.explevel, job.places,
               nrCandidates, erating, emoney, '{}'
        INTO job_detail;

        for jskill in select s.skillcategory, s.skill from skills s, job_skills_through jst
        where jst.job_id = job.id and jst.skill_id = s.id
        loop
            job_detail.skills := job_detail.skills || jskill;
        end loop;

        jobs_details := jobs_details || job_detail;
    end loop;

    foreach job_detail in array jobs_details
    loop
        return next job_detail;
    end loop;
END;
$$;


select apply_for_job(1, 2);
select * from get_applicants(1);
select select_candidate(1, 1);
select * from get_accepted(1);
select * from get_accepted_jobs(2);
select finish_job(1);
select * from get_history_jobs(1);



SELECT * from get_jobs(
    NULL,
    '',
    ARRAY['Begginer'::EXPERIENCE, 'Intermediate'::EXPERIENCE, 'Expert'::EXPERIENCE],
    ARRAY[(0, NULL)::wage_range],
    NULL,
    9);