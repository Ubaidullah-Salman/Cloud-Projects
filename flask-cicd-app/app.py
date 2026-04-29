from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return '''
    <h1>Flask CI/CD Pipeline on AWS Cloud</h1>
    <h2>Deployed automatically via CodePipeline → CodeBuild → CodeDeploy</h2>
    <h3>Fully AWS CI/CD Pipeline Working Project</h3>
    '''

@app.route('/health')
def health():
    return {'status': 'healthy'}, 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
