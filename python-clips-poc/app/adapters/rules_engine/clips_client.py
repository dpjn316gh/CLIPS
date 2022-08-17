import clips

from app.adapters.aws.aws_utils import loading_clips_files_from_s3

localhost_clips_knowledge_base_path = "app/knowledge_base/localhost/bold-batch.bat"
aws_clips_knowledge_base_path = "/tmp/bold-batch.bat"


def get_clips_for_localhost():
    clips_environment = clips.Environment()
    clips_environment.batch_star(localhost_clips_knowledge_base_path)
    return clips_environment


def get_clips_for_aws():
    clips_environment = clips.Environment()
    loading_clips_files_from_s3()
    clips_environment.batch_star(aws_clips_knowledge_base_path)
    return clips_environment
