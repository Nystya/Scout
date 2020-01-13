import psycopg2
import traceback
from passlib.hash import pbkdf2_sha256
from uuid import uuid4

conn = psycopg2.connect(database="scout", user="postgres", password="postgres", host="127.0.0.1", port="5432")
conn.set_session(autocommit=True)
cur = conn.cursor()

class RequstUser():
    def __init__(self, uid, type):
        self.uid = uid
        self.type = type

class User():
    def __init__(self, type, mail, password):
        self.type = type
        self.mail = mail
        self._set_password_(password)
        self.token = uuid4().__str__()

    def create(self):
        try:
            cur.execute("CALL public.create_user(%s, %s, %s, %s);",
                        [self.type, self.mail, self.password, self.token])
            return {"token": self.token, "type": self.type}
        except Exception as error:
            raise error

    def _set_password_(self, password):
        self.password = pbkdf2_sha256.hash(password)

    @staticmethod
    def login(mail, password):
        try:
            cur.callproc('public.login_user', (mail,))
            row = cur.fetchone()
            if row is None:
                return None

            print(row)
            if pbkdf2_sha256.verify(password, row[0]):
                return {"token": row[1], "type": row[2]}

            return None

        except Exception as err:
            raise err

    @staticmethod
    def authenticate(token):
        try:
            cur.callproc('public.authenticate_user', (token, ))
            row = cur.fetchone()
            if row is None:
                return None

            (uid, type) = row
            return RequstUser(uid, type)

        except Exception as err:
            raise err

class Employer():
    def __init__(self, phone, lastName, firstName, rating, jobsPosted, moneySpent):
        self.phone = phone
        self.lastName = lastName
        self.firstName = firstName
        self.rating = rating
        self.jobsPosted = jobsPosted
        self.moneySpent = moneySpent

    def serialize(self):
        return {
            "phone": self.phone,
            "lastName": self.lastName,
            "firstName": self.firstName,
            "rating": self.rating,
            "jobsPosted": self.jobsPosted,
            "moneySpent": self.moneySpent
        }

    @staticmethod
    def get_profile(euid):
        try:
            cur.callproc('get_employer_profile', (euid,))
            row = cur.fetchone()
            if row is None:
                return None

            (phone, lastName, firstName, rating, jobsPosted, moneySpent) = row
            return Employer(phone, lastName, firstName, rating, jobsPosted, moneySpent).serialize()

        except Exception as err:
            raise err

    @staticmethod
    def edit_profile(uid, kwargs):
        try:
            cur.callproc('edit_employer_profile', (
                uid,
                kwargs.get("lastName"),
                kwargs.get("firstName"),
                kwargs.get("phone"),
            ))
            row = cur.fetchone()
            if row is None:
                return None

            (phone, lastName, firstName, rating, jobsPosted, moneySpent) = row
            return Employer(phone, lastName, firstName, rating, jobsPosted, moneySpent).serialize()
        except Exception as err:
            raise err

class Freelancer():
    def __init__(self, phone, lastName, firstName, rating, description, photo, mainSkill, balance, exp=None, uid=None, fid=None):
        self.phone = phone
        self.lastName = lastName
        self.firstName = firstName
        self.rating = rating
        self.description = description
        self.photo = photo
        self.mainSkill = mainSkill
        self.exp = exp
        self.uid = uid
        self.fid = fid
        self.balance = balance

    def serialize(self):
        return {
            "phone": self.phone,
            "lastName": self.lastName,
            "firstName": self.firstName,
            "rating": self.rating,
            "description": self.description,
            "photo": self.photo,
            "mainSkill": self.mainSkill,
            "experience": self.exp,
            "uid": self.uid,
            "fid": self.fid,
            "balance": self.balance
        }

    @staticmethod
    def get_profile(fuid):
        try:
            cur.callproc('get_freelancer_profile', (fuid, ))
            row = cur.fetchone()
            if row is None:
                return None
            print(row)
            (phone, lastName, firstName, rating, description, photo, mainSkill, balance) = row
            return Freelancer(phone, lastName, firstName, rating, description, photo, mainSkill, balance).serialize()
        except Exception as err:
            raise err

    @staticmethod
    def edit_profile(uid, kwargs):
        try:
            cur.callproc('edit_freelancer_profile', (
                uid,
                kwargs.get("lastName"),
                kwargs.get("firstName"),
                kwargs.get("phone"),
                kwargs.get("description"),
                kwargs.get("photo"),
                kwargs.get("mainSkill"),
                kwargs.get("experience"),
            ))
            row = cur.fetchone()
            if row is None:
                return None

            (phone, lastName, firstName, rating, description, photo, mainSkill, balance) = row
            return Freelancer(phone, lastName, firstName, rating, description, photo, mainSkill, balance).serialize()

        except Exception as err:
            raise err

#############################################################################
#############################################################################
#############################################################################

class Service():
    def __init__(self, id, service):
        self.id = id
        self.service = service

    def serialize(self):
        return {
            "id": self.id,
            "service": self.service
        }

    @staticmethod
    def get_services():
        try:
            services = []
            cur.callproc('get_service_categories', [])
            rows = cur.fetchall()
            for row in rows:
                services.append(Service(row[0], row[1]).serialize())

            return services

        except Exception as err:
            raise err

class SkillCategory():
    def __init__(self, id, category):
        self.id = id
        self.category = category

    def serialize(self):
        return {
            "id": self.id,
            "category": self.category
        }

    @staticmethod
    def get_categories(sid):
        try:
            categories = []
            cur.callproc('get_skill_categories', (sid,))
            rows = cur.fetchall()
            for row in rows:
                categories.append(SkillCategory(row[0], row[2]).serialize())

            return categories

        except Exception as err:
            raise err

    @staticmethod
    def get_user_categories(uid):
        try:
            categories = []
            cur.callproc('get_user_skill_categories', (uid,))
            rows = cur.fetchall()
            for row in rows:
                print(row)
                categories.append(SkillCategory(row[0], row[2]).serialize())

            return categories

        except Exception as err:
            raise err

    @staticmethod
    def set_user_categories(uid, categs):
        try:
            cur.callproc('set_user_skill_categories', (uid, categs))
        except Exception as err:
            raise err

class Skill():
    def __init__(self, id, skill, scid=None):
        self.id = id
        self.scid = scid
        self.skill = skill

    def serialize(self):
        data = {
            "id": self.id,
            "skill": self.skill
        }

        if self.scid:
            data["scid"] = self.scid

        return data

    @staticmethod
    def get_skills(scid):
        try:
            skills = []
            cur.callproc('get_skills', (scid,))
            rows = cur.fetchall()
            for row in rows:
                skills.append(Skill(row[0], row[2]).serialize())

            return skills

        except Exception as err:
            raise err

    @staticmethod
    def get_user_skills(uid):
        try:
            skills = []
            cur.callproc('get_user_skills', (uid,))
            rows = cur.fetchall()
            for row in rows:
                skills.append(Skill(row[0], row[2], row[1]).serialize())

            return skills

        except Exception as err:
            raise err

    @staticmethod
    def set_user_skills(uid, categs, skills):
        try:
            cur.callproc('set_user_skills', (uid, categs, skills))
        except Exception as err:
            raise err

#############################################################################
#############################################################################
#############################################################################

from psycopg2.extensions import AsIs, ISQLQuote
class Skill_Record():
    def __init__(self, categ, skill):
        self.categ = categ
        self.skill = skill

    def __conform__(self, protocol):
        if protocol is ISQLQuote:
            return AsIs("({categ}, '{skill}')::skill_record".format(categ=self.categ, skill=self.skill))
        return None

class Experience():
    def __init__(self, exp):
        self.exp = exp

    def __conform__(self, protocol):
        if protocol is ISQLQuote:
            return AsIs("'{exp}'::EXPERIENCE".format(exp=self.exp))

class Wage_Range():
    def __init__(self, low, high):
        self.low = low
        self.high = high

    def __conform__(self, protocol):
        if protocol is ISQLQuote:
            if self.high is None:
                self.high = 'NULL'
            return AsIs("({low}, {high})::wage_range".format(low=self.low, high=self.high))


class Job():
    def __init__(self, euid, title, service, category, exp,
                 wage, places, description, skills, postTime=None,
                id=None, erating=None, nrOfCandidates=None, moneySpent=None):
        self.id = id
        self.euid = euid
        self.title = title
        self.service = service
        self.category = category
        self.exp = exp
        self.wage = wage
        self.places = places
        self.description = description
        self.skills = skills
        self.postTime = postTime
        self.erating=erating
        self.nrOfCandidates = nrOfCandidates
        self.moneySpent = moneySpent

    def serialize(self):
        return {
            "id": self.id,
            "euid": self.euid,
            "title": self.title,
            "service": self.service,
            "category": self.category,
            "experience": self.exp,
            "wage": self.wage,
            "places": self.places,
            "descriptio": self.description,
            "skills": self.skills,
            "postTime": self.postTime,
            "erating": self.erating,
            "nrOfCandidates": self.nrOfCandidates,
            "moneySpent": self.moneySpent
        }

    def create(self):
        try:
            skills = [Skill_Record(s[0], s[1]) for s in self.skills]
            cur.callproc('create_job', (
                self.euid,
                self.title,
                self.service,
                self.category,
                self.exp,
                self.wage,
                self.places,
                self.description,
                skills
            ))
            job = cur.fetchone()
            if job is None:
                return None

            job = Job(
                id=job[0],
                euid=job[1],
                postTime=job[2],
                title=job[4],
                service=job[5],
                category=job[6],
                exp=job[7],
                wage=job[8],
                places=job[9],
                description=job[10],
                skills=self.skills
            )
            return job.serialize()
        except Exception as err:
            raise err

    @staticmethod
    def get_jobs(euid, title, explevel, wage, skills, service):
        try:
            jobs = []
            explevel = [Experience(exp) for exp in explevel]
            wage = [Wage_Range(w[0], w[1]) for w in wage]

            cur.callproc('get_jobs', (
                euid,
                title,
                explevel,
                wage,
                skills,
                service
            ))
            job = cur.fetchone()
            while job is not None:
                print(job)
                rjob = Job(
                    id=job[0],
                    euid=job[1],
                    title=job[2],
                    service=job[3],
                    category=job[4],
                    wage=job[5],
                    postTime=job[6],
                    description=job[7],
                    exp=job[8],
                    places=job[9],
                    nrOfCandidates=job[10],
                    erating=job[11],
                    moneySpent=job[12],
                    skills=job[13]
                )
                jobs.append(rjob.serialize())
                job = cur.fetchone()
            return jobs
        except Exception as err:
            raise err

    @staticmethod
    def apply_for_job(jid, fuid):
        try:
            cur.callproc('apply_for_job', (jid, fuid))
        except Exception as err:
            raise err

    @staticmethod
    def get_applicants(jid):
        try:
            applicants = []
            cur.callproc('get_applicants', (jid, ))
            profile = cur.fetchone()
            while profile is not None:
                print(profile)
                (fid, uid, phone, lastName, firstName, rating, _, description, photo, mainSkill, experience, balance) = profile
                f =  Freelancer(phone, lastName, firstName, rating, description, photo, mainSkill, balance, experience, uid, fid).serialize()
                applicants.append(f)
                profile = cur.fetchone()

            return applicants
        except Exception as err:
            raise err

    @staticmethod
    def select_for_job(jid, fid):
        try:
            cur.callproc('select_candidate', (jid, fid))
        except Exception as err:
            raise err

    @staticmethod
    def get_accepted(jid):
        try:
            applicants = []
            cur.callproc('get_accepted', (jid,))
            profile = cur.fetchone()

            while profile is not None:
                print(profile)
                (fid, uid, phone, lastName, firstName, rating, _, description, photo, mainSkill, experience, balance) = profile
                f = Freelancer(phone, lastName, firstName, rating, description, photo, mainSkill, balance, experience, uid,
                               fid).serialize()
                applicants.append(f)
                profile = cur.fetchone()

            return applicants
        except Exception as err:
            raise err

    @staticmethod
    def get_accepted_jobs(fuid):
        try:
            jobs = []

            cur.callproc('get_accepted_jobs', (
                fuid,
            ))

            job = cur.fetchone()
            while job is not None:
                print(job)
                rjob = Job(
                    id=job[0],
                    euid=job[1],
                    title=job[2],
                    service=job[3],
                    category=job[4],
                    wage=job[5],
                    postTime=job[6],
                    description=job[7],
                    exp=job[8],
                    places=job[9],
                    nrOfCandidates=job[10],
                    erating=job[11],
                    moneySpent=job[12],
                    skills=job[13]
                )
                jobs.append(rjob.serialize())
                job = cur.fetchone()
            return jobs
        except Exception as err:
            raise err

    @staticmethod
    def finish_job(euid, jid):
        try:
            cur.callproc('finish_job', (euid, jid))
        except Exception as err:
            raise err

    @staticmethod
    def get_history_jobs(uid):
        try:
            jobs = []

            cur.callproc('get_history_jobs', (
                uid,
            ))

            job = cur.fetchone()
            while job is not None:
                print(job)
                rjob = Job(
                    id=job[0],
                    euid=job[1],
                    title=job[2],
                    service=job[3],
                    category=job[4],
                    wage=job[5],
                    postTime=job[6],
                    description=job[7],
                    exp=job[8],
                    places=job[9],
                    nrOfCandidates=job[10],
                    erating=job[11],
                    moneySpent=job[12],
                    skills=job[13]
                )
                jobs.append(rjob.serialize())
                job = cur.fetchone()
            return jobs
        except Exception as err:
            raise err
