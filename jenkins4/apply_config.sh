    set -e
    echo "disable Setup Wizard"
    # Prevent Setup Wizard when JCasC is enabled
    echo $JENKINS_VERSION > /var/jenkins_home/jenkins.install.UpgradeWizard.state
    echo $JENKINS_VERSION > /var/jenkins_home/jenkins.install.InstallUtil.lastExecVersion
    echo "download plugins"
    # Install missing plugins
    cp /var/jenkins_config/plugins.txt /var/jenkins_home;
    rm -rf /usr/share/jenkins/ref/plugins/*.lock
    version () { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }
    if [ -f "/usr/share/jenkins/jenkins.war" ] && [ -n "$(command -v jenkins-plugin-cli)" 2>/dev/null ] && [ $(version $(jenkins-plugin-cli --version)) -ge $(version "2.1.1") ]; then
      jenkins-plugin-cli --verbose --war "/usr/share/jenkins/jenkins.war" --plugin-file "/var/jenkins_home/plugins.txt" --latest true;
    else
      /usr/local/bin/install-plugins.sh `echo $(cat /var/jenkins_home/plugins.txt)`;
    fi
    echo "copy plugins to shared volume"
    # Copy plugins to shared volume
    yes n | cp -i /usr/share/jenkins/ref/plugins/* /var/jenkins_plugins/;
    echo "finished initialization"
