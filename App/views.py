import traceback
from typing import Optional, Dict, Any

from .models import User, RequstUser, Employer, Freelancer, \
                    Service, SkillCategory, Skill, Job
import psycopg2


def create_user_view(request):
    try:
        data = request.get_json()
        user = User(
            type=data['type'],
            mail=data['mail'],
            password=data['password']
        )

        info = user.create()
        return 201, info
    except (KeyError, psycopg2.errors.IntegrityError):
        return 400, None
    except Exception:
        traceback.print_exc()
        return 500, None


def login_user(request):
    try:
        data = request.get_json()
        token = User.login(data['mail'], data['password'])
        print(token)
        if token:
            return 200, token
        else:
            return 404, None
    except (KeyError, psycopg2.errors.IntegrityError):
        return 400, None
    except Exception:
        traceback.print_exc()
        return 500, None

def get_profile(request):
    try:
        token = request.headers["Authorization"]
        requestUser = User.authenticate(token=token)
        if requestUser:
            if requestUser.type == "employer":
                profile = Employer.get_profile(euid=requestUser.uid)
            else:
                profile = Freelancer.get_profile(fuid=requestUser.uid)
        else:
            return 401, None

        if profile:
            return 200, profile

        return 404, None
    except KeyError:
        return 401, None
    except Exception:
        traceback.print_exc()
        return 500, None

def get_employer_profile(request, id=None):
    try:
        if id:
            profile = Employer.get_profile(euid=id)
        else:
            return 404, None

        if profile:
            return 200, profile

        return 404, None
    except KeyError:
        return 401, None
    except psycopg2.errors.NoDataFound:
        traceback.print_exc()
        return 404, None
    except Exception:
        traceback.print_exc()
        return 500, None

def get_freelancer_profile(request, id=None):
    try:
        if id:
            profile = Freelancer.get_profile(fuid=id)
        else:
            return 404, None

        if profile:
            return 200, profile

        return 404, None
    except KeyError:
        return 401, None
    except psycopg2.errors.NoDataFound:
        traceback.print_exc()
        return 404, None
    except Exception:
        traceback.print_exc()
        return 500, None

def edit_user_profile(request):
    try:
        token = request.headers["Authorization"]
        requestUser = User.authenticate(token=token)
        print(request.get_json())
        if requestUser:
            if requestUser.type == "employer":
                profile = Employer.edit_profile(uid=requestUser.uid, kwargs=request.get_json())
            else:
                profile = Freelancer.edit_profile(uid=requestUser.uid, kwargs=request.get_json())
        else:
            return 401, None

        if profile:
            return 200, profile

        return 404, None
    except KeyError:
        return 401, None
    except psycopg2.errors.NoDataFound:
        return 404, None
    except Exception:
        traceback.print_exc()
        return 500, None

#############################################################################
#############################################################################
#############################################################################

def get_all_services():
    try:
        services = Service.get_services()
        return 200, services
    except Exception:
        traceback.print_exc()
        return 500, None

def get_all_skill_categories(sid):
    try:
        categories = SkillCategory.get_categories(sid=sid)
        return 200, categories
    except Exception:
        traceback.print_exc()
        return 500, None


def get_all_skills(scid):
    try:
        skills = Skill.get_skills(scid=scid)
        return 200, skills
    except Exception:
        traceback.print_exc()
        return 500, None

def get_freelancer_skill_categories(request, id=None):
    try:
        token = request.headers["Authorization"]
        requestUser = User.authenticate(token=token)
        if id:
            categories = SkillCategory.get_user_categories(uid=id)
        else:
            categories = SkillCategory.get_user_categories(uid=requestUser.uid)
        return 200, categories
    except KeyError:
        return 400, None
    except Exception:
        traceback.print_exc()
        return 500, None

def get_freelancer_skills(request, id=None):
    try:
        token = request.headers["Authorization"]
        requestUser = User.authenticate(token=token)
        if id:
            skills = Skill.get_user_skills(uid=id)
        else:
            skills = Skill.get_user_skills(uid=requestUser.uid)
        return 200, skills
    except KeyError:
        return 400, None
    except Exception:
        traceback.print_exc()
        return 500, None

def edit_freelancer_skill_categories(request):
    try:
        token = request.headers["Authorization"]
        requestUser = User.authenticate(token=token)

        categories = []

        categories_json = request.get_json()
        for category in categories_json:
            categories.append(category["category"])

        SkillCategory.set_user_categories(uid=requestUser.uid, categs=categories)

        return 200, categories
    except KeyError:
        return 400, None
    except Exception:
        traceback.print_exc()
        return 500, None

def edit_freelancer_skills(request):
    try:
        token = request.headers["Authorization"]
        requestUser = User.authenticate(token=token)

        skills = []
        categs = []

        skills_json = request.get_json()
        for skill in skills_json:
            skills.append(skill["skill"])
            categs.append(skill["scid"])

        Skill.set_user_skills(uid=requestUser.uid, categs=categs, skills=skills)

        return 200, skills_json
    except KeyError:
        return 400, None
    except Exception:
        traceback.print_exc()
        return 500, None

#############################################################################
#############################################################################
#############################################################################

def post_job(request):
    try:
        token = request.headers["Authorization"]
        requestUser = User.authenticate(token=token)
        data = request.get_json()
        skills = [(d["scid"], d["skill"]) for d in data["skills"]]
        if requestUser is not None:
            job = Job(
                euid=requestUser.uid,
                title=data["title"],
                service=data["service"],
                category=data["category"],
                exp=data["experience"],
                wage=data["wage"],
                places=data["places"],
                description=data["description"],
                skills=skills
            )
            job = job.create()

            return 200, job
        return 403, None
    except KeyError:
        traceback.print_exc()
        return 400, None
    except Exception:
        traceback.print_exc()
        return 500, None


def get_jobs(request):
    try:
        employer = request.args.get("employer", None)

        service = None
        token = request.headers["Authorization"]
        requestUser = User.authenticate(token=token)
        if requestUser:
            if requestUser.type == "freelancer":
                profile = Freelancer.get_profile(fuid=requestUser.uid)
                service = profile.get("mainSkill")
            else:
                employer = requestUser.uid
        else:
            return 403, None

        title = request.args.get("title", "")
        skills = request.args.getlist("skills")
        exp = request.args.getlist("exp")
        wage = request.args.getlist("wage")

        if not skills:
            skills = None

        if not exp:
            exp = ['Begginer', 'Intermediate', 'Expert']

        if wage != []:
            wage = [(w[0], w[1]) if w[1] else (w[0], None) for w in [wr.split("-") for wr in wage]]
        else:
            wage = [(0, None)]

        print(employer)
        print(title)
        print(exp)
        print(wage)
        print(skills)
        print(service)

        jobs = Job.get_jobs(
            euid=employer,
            title=title,
            explevel=exp,
            wage=wage,
            skills=skills,
            service=service
        )

        return 200, jobs
    except Exception:
        traceback.print_exc()
        return 500, None


def apply_for_job(request, jid):
    try:
        token = request.headers["Authorization"]
        requestUser = User.authenticate(token=token)

        if requestUser:
            if requestUser.type == "freelancer":
                Job.apply_for_job(jid=jid, fuid=requestUser.uid)
                return 200, None
            else:
                return 403, None
    except psycopg2.errors.IntegrityError:
        return 400, None
    except Exception:
        traceback.print_exc()
        return 500, None

def get_applicants(request, jid):
    try:
        token = request.headers["Authorization"]
        requestUser = User.authenticate(token=token)

        if requestUser:
            if requestUser.type == "employer":
                applicants = Job.get_applicants(jid=jid)
                return 200, applicants
            else:
                return 403, None

    except Exception:
        traceback.print_exc()
        return 500, None

def select_for_job(request, jid):
    try:
        token = request.headers["Authorization"]
        requestUser = User.authenticate(token=token)

        fid = request.get_json().get("selected")

        if requestUser:
            if requestUser.type == "employer":
                applicants = Job.select_for_job(jid=jid, fid=fid)
                return 200, applicants
            else:
                return 403, None
    except Exception:
        traceback.print_exc()
        return 500, None

def get_accepted(request, jid):
    try:
        token = request.headers["Authorization"]
        requestUser = User.authenticate(token=token)

        if requestUser:
            if requestUser.type == "employer":
                applicants = Job.get_accepted(jid=jid)
                return 200, applicants
            else:
                return 403, None

    except Exception:
        traceback.print_exc()
        return 500, None

def get_accepted_jobs(request, id=None):
    try:
        token = request.headers["Authorization"]
        requestUser = User.authenticate(token=token)

        if requestUser:
            if requestUser.type == "freelancer":
                jobs = Job.get_accepted_jobs(fuid=requestUser.uid)
            else:
                return 400, None
            return 200, jobs
        else:
            return 403, None
    except Exception:
        traceback.print_exc()
        return 500, None

def get_history_jobs(request, id=None):
    try:
        token = request.headers["Authorization"]
        requestUser = User.authenticate(token=token)

        if requestUser:
            if id is None:
                jobs = Job.get_history_jobs(uid=requestUser.uid)
            else:
                jobs = Job.get_history_jobs(uid=id)
            return 200, jobs
        else:
            return 403, None
    except Exception:
        traceback.print_exc()
        return 500, None

def finish_job(request, jid):
    try:
        token = request.headers["Authorization"]
        requestUser = User.authenticate(token=token)

        if requestUser:
            if requestUser.type == "employer":
                _ = Job.finish_job(euid=requestUser.uid, jid=jid)
                return 200, None

        return 403, None
    except psycopg2.errors.IntegrityError:
        return 403, None
    except Exception:
        traceback.print_exc()
        return 500, None