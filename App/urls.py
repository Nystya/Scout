from flask import Flask, request, Response, jsonify
from flask_cors import CORS
from App.views import create_user_view, login_user, get_employer_profile, get_freelancer_profile, get_profile, \
                    edit_user_profile, edit_freelancer_skill_categories, edit_freelancer_skills, \
                    get_freelancer_skill_categories, get_freelancer_skills, get_all_skill_categories, \
                    get_all_skills, get_all_services, post_job, get_jobs, get_history_jobs, apply_for_job, \
                    get_applicants, select_for_job, get_accepted, get_accepted_jobs, finish_job

app = Flask("Scout")
CORS(app, supports_credentials=True)

@app.route('/', methods=["GET"])
def index():
    return Response(status=200)

@app.route('/accounts/registration/', methods=["POST"])
def register():
    status, token = create_user_view(request=request)
    if status == 201:
        return jsonify(token)
    else:
        return Response(status=status)

@app.route('/accounts/login/', methods=["POST"])
def login():
    status, token = login_user(request=request)
    if status == 200:
        return jsonify(token)
    else:
        return Response(status=status)

@app.route('/profile/', methods=["GET"])
def self_profile():
    status, profile = get_profile(request)
    if status == 200:
        return jsonify(profile)
    else:
        return Response(status=status)

@app.route('/employer/profile/<int:id>/', methods=["GET"])
def employer_profile(id):
    status, employer = get_employer_profile(request, id)
    if status == 200:
        return jsonify(employer)
    else:
        return Response(status=status)

@app.route('/freelancer/profile/<int:id>/', methods=["GET"])
def freelancer_profile(id):
    status, employer = get_freelancer_profile(request, id)
    if status == 200:
        return jsonify(employer)
    else:
        return Response(status=status)

@app.route('/profile/edit/', methods=["POST"])
def edit_profile():
    status, profile = edit_user_profile(request=request)
    if status == 200:
        return jsonify(profile)
    else:
        return Response(status=status)

######################################################################
######################################################################
######################################################################

@app.route('/services/', methods=["GET"])
def services():
    status, services = get_all_services()
    if status == 200:
        return jsonify(services)
    else:
        return Response(status=status)

@app.route('/skills/categories/<int:sid>/', methods=["GET"])
def skill_categories(sid):
    status, categories = get_all_skill_categories(sid=sid)
    if status == 200:
        return jsonify(categories)
    else:
        return Response(status=status)

@app.route('/skills/<int:scid>/', methods=["GET"])
def skills(scid):
    status, skills = get_all_skills(scid)
    if status == 200:
        return jsonify(skills)
    else:
        return Response(status=status)

######################################################################
######################################################################

@app.route('/freelancer/skills/categories/', methods=["GET"])
def self_skill_categories():
    status, categories = get_freelancer_skill_categories(request)
    if status == 200:
        return jsonify(categories)
    else:
        return Response(status=status)

@app.route('/freelancer/skills/', methods=["GET"])
def self_skills():
    status, skills = get_freelancer_skills(request)
    if status == 200:
        return jsonify(skills)
    else:
        return Response(status=status)

@app.route('/freelancer/skills/categories/<int:id>/', methods=["GET"])
def freelancer_skill_categories(request, id):
    status, categories = get_freelancer_skill_categories(id)
    if status == 200:
        return jsonify(categories)
    else:
        return Response(status=status)

@app.route('/freelancer/skills/<int:id>/', methods=["GET"])
def freelancer_skills(id):
    status, skills = get_freelancer_skills(request, id)
    if status == 200:
        return jsonify(skills)
    else:
        return Response(status=status)

######################################################################
######################################################################

@app.route('/freelancer/skills/categories/edit/', methods=["POST"])
def edit_skill_categories():
    status, categories = edit_freelancer_skill_categories(request)
    if status == 200:
        return jsonify(categories)
    else:
        return Response(status=status)

@app.route('/freelancer/skills/edit/', methods=["POST"])
def edit_skills():
    status, skills = edit_freelancer_skills(request)
    if status == 200:
        return jsonify(skills)
    else:
        return Response(status=status)

######################################################################
######################################################################

@app.route('/jobs/', methods=["GET", "POST"])
def jobs():
    if request.method == "GET":
        status, jobs = get_jobs(request)
        if status == 200:
            return jsonify(jobs)
    elif request.method == "POST":
        status, job = post_job(request)
        if status == 200:
            return jsonify(job)

@app.route('/jobs/apply/<int:jid>/', methods=["POST"])
def apply(jid):
    status, _ = apply_for_job(request, jid)

    return Response(status=status)

@app.route('/jobs/candidates/<int:jid>/', methods=["GET"])
def candidates(jid):
    status, candidates = get_applicants(request=request, jid=jid)
    if status == 200:
        return jsonify(candidates)

    return Response(status=status)


@app.route('/jobs/select/<int:jid>/', methods=["POST"])
def select(jid):
    status, _ = select_for_job(request=request, jid=jid)
    return Response(status=status)

@app.route('/jobs/accepted/<int:jid>/', methods=["GET"])
def accepted(jid):
    status, candidates = get_accepted(request=request, jid=jid)
    if status == 200:
        return jsonify(candidates)

    return Response(status=status)

@app.route('/jobs/myjobs/', methods=["GET"])
def myjobs():
    if request.method == "GET":
        status, jobs = get_accepted_jobs(request)
        if status == 200:
            return jsonify(jobs)
    return Response(status=status)

@app.route('/jobs/history/', methods=["GET"])
def my_history():
    if request.method == "GET":
        status, jobs = get_history_jobs(request)
        if status == 200:
            return jsonify(jobs)

@app.route('/jobs/history/<int:id>/', methods=["GET"])
def history(id):
    if request.method == "GET":
        status, jobs = get_history_jobs(request, id)
        if status == 200:
            return jsonify(jobs)
    return Response(status=status)


@app.route('/jobs/finish/<int:jid>/', methods=["POST"])
def finish(jid):
    status, _ = finish_job(request=request, jid=jid)
    return Response(status=status)


if __name__ == '__main__':
    app.run('0.0.0.0', debug=True)