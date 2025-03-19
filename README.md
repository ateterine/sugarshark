# sugarshark

## Installation instructions

Login as **fpp** User
Run this to download setup file

```
wget -O setup.sh https://fpp-accordios.s3.us-east-1.amazonaws.com/setup.sh
```

Then run this to make that file executable

```
chmod +x setup.sh
```

Then execute script

```
./setup.sh
```

It will update `apt-get`, download and install `awscli` and will ask for AWS access Key and Secret. It will also ask for default region [*example displays those values already provided*]:

```
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
awscli is already the newest version (2.9.19-1).
0 upgraded, 0 newly installed, 0 to remove and 46 not upgraded.
AWS Access Key ID [****************BV7Z]:
AWS Secret Access Key [****************ZwrJ]:
Default region name [us-east-1]:
Default output format [None]:
```

Then it will ask for optional subfolder for videos source:
`Enter the subpath for S3 bucket (leave empty to keep default):`

The script will then open **crontab**, paste this at the end of the file:

```
@reboot /home/fpp/s3_poll_sync.sh >> /home/fpp/logs/s3_sync.log 2>&1 &
```

Reboot raspberry pi by running `shutdown -r now`, might need to run as `sudo`.
