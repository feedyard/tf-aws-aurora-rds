from invoke import task

@task
def buildlocal(ctx):
    ctx.run('terraform init')
    ctx.run('terraform plan -var-file test_environment.json')